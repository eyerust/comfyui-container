FROM pytorch/pytorch:2.8.0-cuda12.9-cudnn9-runtime

ARG COMFYUI_VERSION=master

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    aria2 \
    unzip \
    p7zip-full \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

RUN git checkout ${COMFYUI_VERSION}

RUN pip install -r requirements.txt

# Skeleton and Symlink Setup
RUN mkdir -p /opt/data-skeleton /data && \
    for dir in models input output custom_nodes; do \
        mv "/app/${dir}" "/opt/data-skeleton/${dir}" && \
        ln -s "/data/${dir}" "/app/${dir}"; \
    done

# Install ComfyUI Manager
RUN mkdir -p /opt/preinstalled_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /opt/preinstalled_nodes/comfyui-manager
RUN pip install -r /opt/preinstalled_nodes/comfyui-manager/requirements.txt

# Copy entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8188

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["python", "main.py"]