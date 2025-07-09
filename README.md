# comfyui-docker
This repository provides a Dockerfile and docker-compose.yml configuration to quickly set up and run ComfyUI in a containerized environment. 
It comes pre-configured for GPU support with NVIDIA hardware, although it can be adapted for AMD or Intel GPUs.

## Overview

ComfyUI is a modular, flexible user interface for machine learning models. 
This Dockerized version allows you to run ComfyUI with ease while handling dependencies and GPU support.

## Features

- Dockerized Environment: Easily deploy ComfyUI with all necessary dependencies.
- GPU Support: Default setup for NVIDIA GPUs, with options for AMD/Intel GPUs.
- Persistent Volumes: Mounts for models, outputs, and custom nodes to ensure persistent data.


## Prerequisites

Before you begin, ensure you have these dependencies installed:
- Docker
- Docker Compose 
- Nvidia container toolkit or equivalent for your system. Note: may come bundled with docker-desktop

If lacking any of these, please refer to each documentation on how to install on your system


## Getting started

1. Clone the repository
```shell
git clone https://github.com/charlesgiry/comfyui-docker.git 
cd comfyui-docker
```

2. Build the Docker Image
```shell
docker compose build
```

3. Start the container

Attached mode (will display logs in the terminal):
```shell
docker compose up
```
Press `Ctrl + C` to stop the container.


Detached mode:
```shell
docker compose up -d
```
To stop the container:
```shell
docker compose down
```

4. Access comfyui and start using it: http://localhost:8188

## Setting up the "models" folder

ComfyUI requires a specific folder structure under models, with files such as `checkpoints` and `configs`. 
To quickly set this up, you can use the provided Python script `download.py`.

### Running the script:
- You can run the script on your local machine if you have Python and the requests library installed.
- Alternatively, you can run the script directly inside the container.
```shell
docker compose exec comfyui python3 download.py
```
This will download the necessary model files directly from the [ComfyUI GitHub repository](https://github.com/comfyanonymous/ComfyUI) using the Github API.

Note: if you are rate-limited by the API, you can also clone the project and keep only the "models" folder.

## GPU Support
As I only own a NVIDIA GPU, I built this image with this it mind. 
You should be able to slightly modify the project to make an image working with an AMD or Intel GPU

You will need to modify this line inside the `Dockerfile`:
```dockerfile
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129
```

You will also need to modify the `docker-compose.yml` file:
```yaml
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [ gpu ]
```

### AMD GPUs
This documentation may be out of date by the time you download it, so you should refer to https://pytorch.org/get-started/locally/ (Linux OS, with pip package)

At the time of writing, you will need to set the value in the `dockerfile` to:
```dockerfile
# Install pytorch for AMD GPU
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm6.4
```
- Sed command to automatically edit the relevant line:
```shell
sed -i 's/https:\/\/download.pytorch.org\/whl\/nightly\/cu129/https:\/\/download.pytorch.org\/whl\/nightly\/rocm6.4/g' Dockerfile
```

You will also need to edit the `docker-compose.yml` file, but this may depend more closely on your system

### Intel GPUs
This documentation may be out of date by the time you download it, so you should refer to https://docs.pytorch.org/docs/stable/notes/get_start_xpu.html

At the time of writing, you will need to set the value in the `dockerfile` to:
```dockerfile
# Install pytorch for Intel GPU
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu
```
- Sed command to automatically edit the relevant line:
```shell
sed -i 's/https:\/\/download.pytorch.org\/whl\/nightly\/cu129/https:\/\/download.pytorch.org\/whl\/nightly\/xpu/g' Dockerfile
```

You will also need to edit the `docker-compose.yml` file, but this may depend more closely on your system


## Additional resources
For more information about ComfyUI itself, refer to the official documentation:
- https://docs.comfy.org/

There is a thriving community around ComfyUI, you may also want to engage with it, for example on reddit:
- https://www.reddit.com/r/comfyui/