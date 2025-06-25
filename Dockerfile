FROM ubuntu:24.04

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3.12  \
        python3-pip  \
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
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129

# Install ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git . && \
    pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "main.py", "--port", "8080", "--listen"]
