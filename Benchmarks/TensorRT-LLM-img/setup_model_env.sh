#!/bin/bash

# Install dependencies for each model to pipenv directory to prevent conflicts
# Once environments are initialized it can be used like follows
# cd /workspace/TensorRT-LLM/env/llama; pipenv run python3 -c "import torch; print(torch.__version__)"
set -xeuo pipefail

: "${MODEL_LIST:="llama phi"}"
: "${PYTHON_VERSION:=3.10}"
export PIPENV_VENV_IN_PROJECT=1

for MODEL in $MODEL_LIST
do
    echo $MODEL
    MODEL_HOME=/workspace/TensorRT-LLM/env/$MODEL
    mkdir -p $MODEL_HOME
    cd $MODEL_HOME
    # Install packages
    cp /workspace/TensorRT-LLM/examples/${MODEL}/requirements.txt .
    pipenv install --verbose --python $PYTHON_VERSION -r requirements.txt
    # Add library path to nvidia's libraries
    echo "export LD_LIBRARY_PATH=:\$VIRTUAL_ENV/lib/python${PYTHON_VERSION}/site-packages/nvidia/nvjitlink/lib:\$LD_LIBRARY_PATH" >> .env
    # Check environment
    #pipenv run python3 -c 'import tensorrt_llm'
done
