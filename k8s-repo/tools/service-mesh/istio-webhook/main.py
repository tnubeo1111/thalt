from flask import Flask, request, jsonify
import json
import os
import logging
from kubernetes import client
from kubernetes.client.rest import ApiException
from tenacity import retry, stop_after_attempt, wait_fixed

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Environment variables
PRIMARY_CLUSTER_API = os.getenv("PRIMARY_CLUSTER_API")
PRIMARY_CLUSTER_TOKEN = os.getenv("PRIMARY_CLUSTER_TOKEN")

if not PRIMARY_CLUSTER_API or not PRIMARY_CLUSTER_TOKEN:
    logger.error("Missing PRIMARY_CLUSTER_API or PRIMARY_CLUSTER_TOKEN")
    raise Exception("PRIMARY_CLUSTER_API and PRIMARY_CLUSTER_TOKEN must be set")

# Kubernetes client configuration
try:
    configuration = client.Configuration()
    configuration.host = PRIMARY_CLUSTER_API
    configuration.api_key['authorization'] = f"Bearer {PRIMARY_CLUSTER_TOKEN}"
    configuration.verify_ssl = False  # Set to True in production with proper CA
    primary_client = client.ApiClient(configuration)
    core_v1 = client.CoreV1Api(primary_client)
    custom_objects_api = client.CustomObjectsApi(primary_client)
except Exception as e:
    logger.error(f"Failed to initialize Kubernetes client: {str(e)}")
    raise

# Istio resources with supported API versions
ISTIO_RESOURCES = {
    "WasmPlugin": {"group": "extensions.istio.io", "versions": ["v1alpha1"], "plural": "wasmplugins"},
    "DestinationRule": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "destinationrules"},
    "EnvoyFilter": {"group": "networking.istio.io", "versions": ["v1alpha3"], "plural": "envoyfilters"},
    "Gateway": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "gateways"},
    "ProxyConfig": {"group": "networking.istio.io", "versions": ["v1beta1"], "plural": "proxyconfigs"},
    "ServiceEntry": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "serviceentries"},
    "Sidecar": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "sidecars"},
    "VirtualService": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "virtualservices"},
    "WorkloadEntry": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "workloadentries"},
    "WorkloadGroup": {"group": "networking.istio.io", "versions": ["v1", "v1alpha3"], "plural": "workloadgroups"},
    "AuthorizationPolicy": {"group": "security.istio.io", "versions": ["v1"], "plural": "authorizationpolicies"},
    "PeerAuthentication": {"group": "security.istio.io", "versions": ["v1"], "plural": "peerauthentications"},
    "RequestAuthentication": {"group": "security.istio.io", "versions": ["v1"], "plural": "requestauthentications"},
    "Telemetry": {"group": "telemetry.istio.io", "versions": ["v1"], "plural": "telemetries"}
}

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def create_namespace(namespace_name):
    logger.debug(f"Attempting to create namespace: {namespace_name}")
    try:
        core_v1.create_namespace(body={
            "apiVersion": "v1",
            "kind": "Namespace",
            "metadata": {"name": namespace_name}
        })
        logger.info(f"Created namespace {namespace_name} on primary cluster")
    except ApiException as e:
        if e.status == 409:
            logger.info(f"Namespace {namespace_name} already exists, ignoring")
        else:
            logger.error(f"Failed to create namespace {namespace_name}: {str(e)}")
            raise

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def delete_namespace(namespace_name):
    logger.debug(f"Attempting to delete namespace: {namespace_name}")
    try:
        for kind, info in ISTIO_RESOURCES.items():
            group = info["group"]
            plural = info["plural"]
            for version in info["versions"]:
                try:
                    resources = custom_objects_api.list_namespaced_custom_object(
                        group=group,
                        version=version,
                        namespace=namespace_name,
                        plural=plural
                    )
                    for item in resources.get("items", []):
                        name = item["metadata"]["name"]
                        try:
                            custom_objects_api.delete_namespaced_custom_object(
                                group=group,
                                version=version,
                                namespace=namespace_name,
                                plural=plural,
                                name=name
                            )
                            logger.info(f"Deleted {kind} {name} in namespace {namespace_name} with version {version}")
                        except ApiException as e:
                            if e.status == 404:
                                logger.info(f"{kind} {name} not found in namespace {namespace_name}, ignoring")
                            else:
                                logger.error(f"Failed to delete {kind} {name} in namespace {namespace_name}: {str(e)}")
                except ApiException as e:
                    if e.status == 404:
                        logger.info(f"{plural} with version {version} not found in namespace {namespace_name}, ignoring")
                    else:
                        logger.error(f"Failed to list {plural} in namespace {namespace_name}: {str(e)}")
        core_v1.delete_namespace(name=namespace_name)
        logger.info(f"Successfully deleted namespace {namespace_name}")
    except ApiException as e:
        if e.status == 404:
            logger.info(f"Namespace {namespace_name} not found, ignoring")
        else:
            logger.error(f"Failed to delete namespace {namespace_name}: {str(e)}")
            raise

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def check_resource_exists(group, version, namespace, plural, name):
    logger.debug(f"Checking if {plural}/{name} exists in namespace {namespace} with version {version}")
    try:
        resource = custom_objects_api.get_namespaced_custom_object(
            group=group,
            version=version,
            namespace=namespace,
            plural=plural,
            name=name
        )
        logger.debug(f"{plural}/{name} exists in namespace {namespace}")
        return True, resource
    except ApiException as e:
        if e.status == 404:
            logger.debug(f"{plural}/{name} does not exist in namespace {namespace}")
            return False, None
        else:
            logger.error(f"Failed to check {plural}/{name} in namespace {namespace}: {str(e)}")
            raise

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def create_custom_object(group, version, namespace, plural, body):
    logger.debug(f"Attempting to create {plural} in namespace {namespace} with version {version}")
    logger.debug(f"Create body: {json.dumps(body, indent=2)}")
    try:
        create_namespace(namespace)
        custom_objects_api.create_namespaced_custom_object(
            group=group,
            version=version,
            namespace=namespace,
            plural=plural,
            body=body
        )
        logger.info(f"Successfully created {plural} in namespace {namespace} with version {version}")
    except ApiException as e:
        logger.error(f"Failed to create {plural} in namespace {namespace}: {str(e)}")
        raise

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def update_custom_object(group, version, namespace, plural, name, body):
    logger.debug(f"Attempting to update {plural}/{name} in namespace {namespace} with version {version}")
    logger.debug(f"Update body (original): {json.dumps(body, indent=2)}")
    try:
        create_namespace(namespace)
        exists, current_resource = check_resource_exists(group, version, namespace, plural, name)
        if exists:
            # Use metadata from primary cluster, spec from remote cluster
            updated_body = {
                "apiVersion": body.get("apiVersion", f"{group}/{version}"),
                "kind": body.get("kind", "VirtualService"),
                "metadata": {
                    "name": name,
                    "namespace": namespace,
                    "uid": current_resource["metadata"]["uid"],
                    "resourceVersion": current_resource["metadata"]["resourceVersion"],
                    "annotations": body.get("metadata", {}).get("annotations", {}),
                    "labels": body.get("metadata", {}).get("labels", {})
                },
                "spec": body.get("spec", {})
            }
            logger.debug(f"Update body (adjusted for primary cluster): {json.dumps(updated_body, indent=2)}")
            custom_objects_api.replace_namespaced_custom_object(
                group=group,
                version=version,
                namespace=namespace,
                plural=plural,
                name=name,
                body=updated_body
            )
            logger.info(f"Successfully updated {plural}/{name} in namespace {namespace} with version {version}")
        else:
            logger.info(f"{plural}/{name} not found in namespace {namespace}, attempting to create")
            create_custom_object(group, version, namespace, plural, body)
    except ApiException as e:
        logger.error(f"Failed to update {plural}/{name} in namespace {namespace}: {str(e)}")
        raise

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def delete_custom_object(group, version, namespace, plural, name):
    logger.debug(f"Attempting to delete {plural}/{name} in namespace {namespace} with version {version}")
    try:
        custom_objects_api.delete_namespaced_custom_object(
            group=group,
            version=version,
            namespace=namespace,
            plural=plural,
            name=name
        )
        logger.info(f"Successfully deleted {plural}/{name}")
    except ApiException as e:
        if e.status == 404:
            logger.info(f"{plural}/{name} not found, ignoring")
        else:
            logger.error(f"Failed to delete {plural}/{name}: {str(e)}")
            raise

@app.route("/mutate", methods=["POST"])
def mutate():
    logger.debug("Received webhook request")
    try:
        admission_review = request.get_json()
        if not admission_review or 'request' not in admission_review:
            logger.error("Invalid AdmissionReview: missing 'request' field")
            return jsonify({"error": "Invalid AdmissionReview"}), 400

        request_data = admission_review['request']
        logger.debug(f"AdmissionReview request: {json.dumps(request_data, indent=2)}")
        uid = request_data['uid']
        kind = request_data['kind']['kind']
        namespace = request_data.get('namespace', '')
        operation = request_data['operation']
        name = request_data.get('name', '')
        object_data = request_data.get('object') or request_data.get('oldObject', {})
        api_version = object_data.get('apiVersion', '') if object_data else request_data.get('requestKind', {}).get('version', '')

        logger.info(f"Processing {operation} for {kind} {name} in namespace {namespace}")

        if kind == "Namespace":
            ns_name = name
            if not ns_name:
                logger.error("Namespace name is missing")
                return jsonify({"error": "Namespace name is missing"}), 400
            logger.info(f"Processing Namespace {operation}: {ns_name}")
            try:
                if operation == "CREATE":
                    create_namespace(ns_name)
                elif operation == "DELETE":
                    delete_namespace(ns_name)
            except ApiException as e:
                if e.status in (404, 409):
                    logger.info(f"Ignoring ApiException for namespace {ns_name}: {str(e)}")
                else:
                    logger.error(f"Failed to process namespace {ns_name}: {str(e)}")
                    return jsonify({"error": f"Failed to process namespace: {str(e)}"}), 500

        elif kind in ISTIO_RESOURCES:
            resource_info = ISTIO_RESOURCES[kind]
            versions_to_try = [api_version.split('/')[-1]] if '/' in api_version else resource_info['versions']
            if not name:
                logger.warning(f"Resource name is missing for {kind} {operation} in namespace {namespace}, ignoring")
            else:
                logger.info(f"Processing {kind} {operation} in namespace: {namespace} with versions: {versions_to_try}")
                for version in versions_to_try:
                    try:
                        if operation == "CREATE":
                            if not object_data:
                                logger.error(f"Object data is missing for {kind} CREATE in namespace {namespace}")
                                return jsonify({"error": f"Object data is missing for {kind} CREATE"}), 400
                            create_custom_object(
                                group=resource_info["group"],
                                version=version,
                                namespace=namespace,
                                plural=resource_info["plural"],
                                body=object_data
                            )
                            logger.info(f"Created {kind} {name} in namespace {namespace} with version {version} on primary cluster")
                            break
                        elif operation == "UPDATE":
                            if not object_data:
                                logger.error(f"Object data is missing for {kind} UPDATE in namespace {namespace}")
                                return jsonify({"error": f"Object data is missing for {kind} UPDATE"}), 400
                            update_custom_object(
                                group=resource_info["group"],
                                version=version,
                                namespace=namespace,
                                plural=resource_info["plural"],
                                name=name,
                                body=object_data
                            )
                            logger.info(f"Updated {kind} {name} in namespace {namespace} with version {version} on primary cluster")
                            break
                        elif operation == "DELETE":
                            delete_custom_object(
                                group=resource_info["group"],
                                version=version,
                                namespace=namespace,
                                plural=resource_info["plural"],
                                name=name
                            )
                            logger.info(f"Deleted {kind} {name} in namespace {namespace} with version {version} on primary cluster")
                            break
                    except ApiException as e:
                        if e.status == 404 and version != versions_to_try[-1]:
                            logger.info(f"Version {version} not supported, trying next version")
                            continue
                        logger.error(f"Failed to process {kind} {name} with version {version}: {str(e)}")
                        return jsonify({"error": f"Failed to process {kind}: {str(e)}"}), 500
                    except Exception as e:
                        logger.error(f"Unexpected error processing {kind} {name} with version {version}: {str(e)}", exc_info=True)
                        return jsonify({"error": f"Unexpected error processing {kind}: {str(e)}"}), 500

        else:
            logger.info(f"Ignoring non-Istio resource: {kind}")

        response = {
            "apiVersion": "admission.k8s.io/v1",
            "kind": "AdmissionReview",
            "response": {
                "uid": uid,
                "allowed": True
            }
        }
        logger.debug("Returning successful response")
        return jsonify(response)

    except Exception as e:
        logger.error(f"Webhook error: {str(e)}", exc_info=True)
        return jsonify({"error": f"Webhook error: {str(e)}"}), 500

if __name__ == "__main__":
    logger.info("Starting webhook server on :8443")
    app.run(ssl_context=('/certs/tls.crt', '/certs/tls.key'), host="0.0.0.0", port=8443)