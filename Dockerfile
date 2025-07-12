FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04 AS base


FROM ubuntu:24.04 AS end-image

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \ 
    PATH=/usr/local/cuda/bin:${PATH} \ 
    CUDNN_INCLUDE_DIR=/usr/local/cuda/include \
    CUDNN_LIB_DIR=/usr/local/cuda/lib64

COPY --from=base /usr/local/cuda* /usr/local/cuda*
COPY --from=base /opt/nvidia /opt/nvidia


RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3.12  \
        python3-pip  \
        python3-dev \
        build-essential \
        git && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /usr/lib/python3.12/EXTERNALLY-MANAGED


USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:$PATH"
WORKDIR /app

# Install pytorch for Nvidia GPU
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129

# Install ComfyUI
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git . && \
    pip3 install --no-cache-dir -r requirements.txt

COPY download.py .


# Additional dependencies
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ffmpeg \
        python3-opencv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


USER ubuntu
RUN pip3 install --no-cache-dir \
        gguf \
        sageattention

EXPOSE 8188

ENTRYPOINT ["python3", "main.py", "--listen"]
