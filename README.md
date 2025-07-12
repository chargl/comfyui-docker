# comfyui-docker
This repository provides a Dockerfile and docker-compose.yml configuration to quickly set up and run ComfyUI in a containerized environment. 
It comes pre-configured for GPU support with NVIDIA hardware.

## Overview

ComfyUI is a modular, flexible user interface for media generation. 
This Dockerized version allows you to run ComfyUI with ease while handling dependencies and GPU support.

## Features

- Dockerized Environment: Easily deploy ComfyUI with all necessary dependencies.
- GPU Support: Default setup for NVIDIA GPUs.
- Persistent Volumes: Mounts for models, outputs, custom nodes and user data to ensure persistent data.


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

You will also need to download the actual models yourself

### Running the script:
- You can run the script on your local machine if you have Python and the requests library installed.
- Alternatively, you can run the script directly inside the container.
```shell
docker compose exec comfyui python3 download.py
```
This will download the necessary model files directly from the [ComfyUI GitHub repository](https://github.com/comfyanonymous/ComfyUI) using the Github API.

Note: if you are rate-limited by the API, you can also clone the project and keep only the "models" folder.

## Additional requirements depending on custom nodes

You may need additional installations for custom nodes. Many of them can be done during runtime (ex: using [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager))
You may encounter some custom nodes requiring additional OS or pip packages. That is why an additional step has been added to the Dockerfile after the setup, to be able to leverage docker build cache

Here's the example currently in the Dockerfile:
```dockerfile
# Install additional apt components you may need
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ffmpeg \
        python3-opencv \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# # Install additional pip components you may need
USER ubuntu
RUN pip3 install --no-cache-dir \
        sageattention \
        gguf
```
In this example, I am adding ffmpeg and opencv for some image detection nodes, as well as installing gguf via pip to allow to run quantized models using [ComfyUI-GGUF](https://github.com/city96/ComfyUI-GGUF) and sageattention for faster inference in certain cases.

The docker build cache allows me to skip every step before these, making subsequent builds much faster when I need to update these dependencies


## Additional resources
For more information about ComfyUI itself, refer to the official documentation:
- https://docs.comfy.org/

There is a thriving community around ComfyUI, you may also want to engage with it, for example on reddit:
- https://www.reddit.com/r/comfyui/

The reference locations for many of the models required by comfyui:
- https://huggingface.co/
- https://civitai.com/