# Server configurations dictionary
server_config = {
    'server1': {'ip': '10.10.10.15', 'port':'8080', 'status': 'active'},
    'server2': {'ip': '10.20.22.25', 'port':'443', 'status': 'inactive'},
    'server3': {'ip': '10.30.35.32', 'port':'9090', 'status': 'active'}
}

# Retrieving information
def get_server_status(server_name):
    return server_config.get(server_name, {}).get('status', 'Server not found')

# Example usage
server_name = 'server1'
status = get_server_status(server_name)
print(f"Status of {server_name}: {status}")