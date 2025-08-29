FROM pytorch/pytorch:2.8.0-cuda12.9-cudnn9-runtime

ARG COMFYUI_VERSION=master

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

RUN git checkout ${COMFYUI_VERSION}

RUN pip install -r requirements.txt

EXPOSE 8188

ENTRYPOINT ["python", "main.py"]