# syntax=docker/dockerfile:1

######################################################
# Assumes that we use official tensorrt_llm image as base for this container
## Base image was build like follows
# https://nvidia.github.io/TensorRT-LLM/installation/build-from-source-linux.html#option-1-build-tensorrt-llm-in-one-step
# apt-get update && apt-get -y install git git-lfs
# git lfs install
# 
# git clone https://github.com/NVIDIA/TensorRT-LLM.git
# cd TensorRT-LLM
## Use original commit from Azure/AI-benchmarking-guide
## But probably it is reasonable to use v0.13.0 or v0.14.0
# git reset --hard a681853d3803ee5893307e812530b5e7004bb6e1
# git submodule update --init --recursive
# git lfs pull
# make -C docker release_build
########################################################
ARG IMAGE_BASE=tensorrt_llm/release:latest
FROM ${IMAGE_BASE}

RUN python3 -m pip install -r examples/llama/requirements.txt
COPY bash_env /usr/bin/
