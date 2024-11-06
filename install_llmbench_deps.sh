#!/bin/bash

set -xeuo pipefail
project_dir="$(dirname $0)"

sudo apt-get update -y
sudo apt-get install -y python3-pip git-lfs
sudo python3 -m pip install pipenv

# Install deps
PYTHON_VERSION=3.10
pushd $project_dir
export PIPENV_VENV_IN_PROJECT=1
pipenv install --verbose --python $PYTHON_VERSION -r requirements.txt
# Add library path to nvidia's libraries
echo "export LD_LIBRARY_PATH=:\$VIRTUAL_ENV/lib/python${PYTHON_VERSION}/site-packages/nvidia/nvjitlink/lib:\$LD_LIBRARY_PATH" > .env
