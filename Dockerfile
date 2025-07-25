FROM ubuntu:24.04 AS end-image

# ENV variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/usr/local/cuda/bin:${PATH} \
    CUDNN_INCLUDE_DIR=/usr/local/cuda/include \
    CUDNN_LIB_DIR=/usr/local/cuda/lib64

# Base dependencies
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        python3.12  \
        python3-pip  \
        python3-dev \
        build-essential \
        git \
        wget && \
    rm -f /usr/lib/python3.12/EXTERNALLY-MANAGED

# Install pytorch for Nvidia GPU
USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:$PATH"
WORKDIR /app
RUN --mount=type=cache,target=/home/ubuntu/.cache/pip \
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129

# Install ComfyUI
RUN --mount=type=cache,target=/home/ubuntu/.cache/pip \
    git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git . && \
    pip3 install -r requirements.txt

# Add the provided utility script in the image
COPY download.py .

# Additional dependencies for custom nodes
# Add cudnn support
# Note: current setup adds a huge footprint, a manual install would likely be better
# FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04 AS base
# FROM end-image
# COPY --from=base --chown=ubuntu:ubuntu /usr/local/cuda* /usr/local/cuda*
# COPY --from=base --chown=ubuntu:ubuntu /opt/nvidia /opt/nvidia

# # Add additional OS based packages
USER root
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get install --no-install-recommends -y \
        ffmpeg \
        python3-opencv

# Add additional pip based packages
USER ubuntu
RUN --mount=type=cache,target=/home/ubuntu/.cache/pip \
    pip3 install \
        gguf \
        sageattention

# Cleanup image
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER ubuntu
EXPOSE 8188

ENTRYPOINT ["python3", "main.py", "--listen"]
