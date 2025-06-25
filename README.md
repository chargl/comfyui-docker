# comfyui-docker
A simple docker image for ComfyUI. The objective was to distill it to the (almost) minimum required to run.

As I only own a NVIDIA GPU, I built this image with this it mind, but you should be able to modify the Dockerfile to make an image working with an AMD or Intel GPU:

You will need to modify this line
```dockerfile
# Install pytorch for Nvidia GPU
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129
```

For AMD:
```dockerfile
# Install pytorch for AMD GPU
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm6.4
```
- Sed command:
```
sed -i 's/https:\/\/download.pytorch.org\/whl\/nightly\/cu129/https:\/\/download.pytorch.org\/whl\/nightly\/rocm6.4/g' Dockerfile
```

For Intel:
```dockerfile
# Install pytorch for Intel GPU
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu
```
- Sed command:
```
sed -i 's/https:\/\/download.pytorch.org\/whl\/nightly\/cu129/https:\/\/download.pytorch.org\/whl\/nightly\/xpu/g' Dockerfile
```