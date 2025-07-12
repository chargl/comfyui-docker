FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

    # Install apt prerequisites
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3.12 \
        python3-pip \
        python3-dev \
        build-essential \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /usr/lib/python3.12/EXTERNALLY-MANAGED

# Install ComfyUI
USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:$PATH"
WORKDIR /app
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git . && \
    pip3 install --no-cache-dir -r requirements.txt

# Add the small script to regenerate the models folder architecture if needed
COPY download.py .

# Install additional apt components you may need
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ffmpeg \
        python3-opencv 

# # Install additional pip components you may need
USER ubuntu
RUN pip3 install --no-cache-dir \
        sageattention \
        gguf


EXPOSE 8188

ENTRYPOINT ["python3", "main.py", "--listen"]
