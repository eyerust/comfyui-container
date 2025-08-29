#!/bin/bash
set -e

INITIALIZED_FLAG="/data/.initialized"
MANAGER_SOURCE_PATH="/opt/preinstalled_nodes/comfyui-manager"
MANAGER_SYMLINK_PATH="/data/custom_nodes/comfyui-manager"

if [ ! -f "$INITIALIZED_FLAG" ]; then
    echo "First run detected. Populating data volume from skeleton..."
    cp -a /opt/data-skeleton/. /data/

    echo "Initialization complete. Creating .initialized flag."
    touch "$INITIALIZED_FLAG"
else
    echo "Data volume already initialized. Skipping population."
fi

if [ ! -e "$MANAGER_SYMLINK_PATH" ]; then
  echo "ComfyUI-Manager symlink not found, creating..."
  mkdir -p /data/custom_nodes
  ln -s "$MANAGER_SOURCE_PATH" "$MANAGER_SYMLINK_PATH"
fi

exec "$@"