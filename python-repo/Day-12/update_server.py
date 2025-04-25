def update_server_config(file_path, key, value):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        for line in lines:
            if key in line:
                file.write(key + ' = ' + value + '\n')
            else:
                file.write(line)

if __name__ == "__main__":
    file_path = input("Enter the path to the server configuration file: ")
    key = input("Enter the configuration key to update: ")
    value = input("Enter the new value for the configuration key: ")
    update_server_config(file_path, key, value)