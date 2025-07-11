FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3.12 \
        python3-pip \
        python3-dev \
        build-essential \
        git \
        ffmpeg \
        python3-opencv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /usr/lib/python3.12/EXTERNALLY-MANAGED


USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:$PATH"
WORKDIR /app

# Install pytorch for Nvidia GPU
# RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129 && \
#    pip3 install --no-cache-dir sageattention

# Install ComfyUI
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git . && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir sageattention

COPY download.py .

EXPOSE 8188

ENTRYPOINT ["python3", "main.py", "--listen"]
