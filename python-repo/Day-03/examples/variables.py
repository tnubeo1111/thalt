# Define configuration variables for a web server
service_name = "server_web"
port = 80
is_https_enabled = True
max_connections = 1000

# Print the configuration
print(f"Service Name: {service_name}")
print(f"Port: {port}")
print(f"HTTPS Enabled: {is_https_enabled}")
print(f"Max Connections: {max_connections}")

# Update configuration values
port = 443
is_https_enabled = False

# Print the updated configuration
print(f"Updated Port: {port}")
print(f"Updated HTTPS Enabled: {is_https_enabled}")
