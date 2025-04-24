import docker

def pull_image():
    client = docker.from_env()
    images_list = ["redis:latest", "nginx:alpine", "python:3.9-slim"]
    for image in images_list:
        print(f"Pulling image: {image}")
        client.images.pull(image)

if __name__ == "__main__":
    pull_image()