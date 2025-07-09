# comfyui-docker
A simple docker image for ComfyUI. The objective was to distill it to the (almost) minimum required to run.

It is also provided with a docker-compose file for simpler commands

Please refer to comfyui docs for additional information on the tool itself: https://docs.comfy.org/

The docker image also contains ffmpeg and opencv which are not natively required by comfyui, as they are used in several custom nodes. 

The container can be accessed from the url http://localhost:8188

## Running this image with a non Nvidia GPU
As I only own a NVIDIA GPU, I built this image with this it mind, but you should be able to modify the Dockerfile to make an image working with an AMD or Intel GPU:

You will need to modify this line inside the `Dockerfile`:
```dockerfile
# Install pytorch for Nvidia GPU
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
```
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
```
sed -i 's/https:\/\/download.pytorch.org\/whl\/nightly\/cu129/https:\/\/download.pytorch.org\/whl\/nightly\/xpu/g' Dockerfile
```

You will also need to edit the `docker-compose.yml` file, but this may depend more closely on your system