import os

def list_files_infolder(folders_path):
    try:                                # Attempt to list the files in the directory
        files = os.listdir(folders_path)
        return files, None
    except FileNotFoundError:           # Handle the case where the folder does not exist
        return None, "Folder does not exist."
    except PermissionError:             # Handle the case where permission is denied
        return None, "Permission denied for folder."
    
def main():
    folder_paths = input("Please enter the folders names with spaces in between: ").split()

    for folder_path in folder_paths:
        files, error_message = list_files_infolder(folder_path)
        if files:
            print(f"Files in {folder_path}:")
            for file in files:
                print(file)
        else:
            print(f"Error in {folder_path}: {error_message}")
        print("-------------------------------------------------")


if __name__ == "__main__":
    main()
