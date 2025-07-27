FROM ubuntu:24.04

# ENV variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Base dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        python3.12  \
        python3-pip  \
        python3-dev \
        build-essential \
        git \
        curl && \
    rm -f /usr/lib/python3.12/EXTERNALLY-MANAGED && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install pytorch for Nvidia GPU
USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:$PATH"
WORKDIR /app
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129

# Install ComfyUI
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git . && \
    pip3 install --no-cache-dir -r requirements.txt

# Add the provided utility script in the image
COPY download.py .

# Additional dependencies for custom nodes
# # Add additional OS based packages
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ffmpeg \
        python3-opencv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add cudnn support
RUN curl -O https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm cuda-keyring_1.1-1_all.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y cuda-nvcc-12-9  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add additional pip based packages
USER ubuntu
RUN pip3 --no-cache-dir install \
        gguf \
        sageattention

EXPOSE 8188
ENTRYPOINT ["python3", "main.py", "--listen"]
