# Azure AI Benchmarking Guide

Inefficient workload optimization can significantly increase operational costs for customers, making it essential to define clear performance benchmarks. This benchmarking guide establishes performance standards across a series of microbenchmarks, tests, and language models. These results are designed to help Azure users maximize efficiency, identify bottlenecks, and fine-tune resource allocation on Azure. By providing detailed performance insights, this guide ensures users can optimize workloads for both cost and performance, improving overall cloud infrastructure utilization. The guide currently supports the ND A100 v4, ND H100 v5, and ND H200 v5 series.

## Tests Included

### 1. Microbenchmark - CublasLt GEMM
The [CuBLASLt General Matrix-to-matrix Multiply](https://github.com/Azure/AI-benchmarking-guide/blob/main/Benchmarks/GEMMCublasLt.py) (GEMM) is a performance evaluation test for the CUDA Basic Linear Algebra Subroutines (CuBLAS) library for matrix and vector operations that leverages the parallel processing capabilities of GPUs. The benchmark is designed to assess the speed of matrix-to-matrix multiplication, which is the fundamental operation in AI applications, by measuring for varying matrix sizes (m, n, and k). The results shown below are with random initialization (best representation of real-life workloads) and datatype FP8.

In the guide, we run CuBLASLt on various matrix sizes. See the [`run_model_sizes`](https://github.com/Azure/AI-benchmarking-guide/blob/7550bcd86a800f94c28dae17d86d3680ce310076/Benchmarks/GEMMCublasLt.py#L246) function in `GEMMCublasLt.py`. 

For Power & Clock Frequency analysis, see [`run_nvml`](https://github.com/Azure/AI-benchmarking-guide/blob/7550bcd86a800f94c28dae17d86d3680ce310076/Benchmarks/GEMMCublasLt.py#L111). It consists of M=N=K=8192 CuBLASLt GEMM ran repeatedly over 120 seconds, precision FP8. The power draw, clock frequency, and GPU temperature are measured and charted over this interval. 

For the sweeps over various values of m, n, and k, see [`run_shmoo`](https://github.com/Azure/AI-benchmarking-guide/blob/7550bcd86a800f94c28dae17d86d3680ce310076/Benchmarks/GEMMCublasLt.py#L103). It generates plots for m,n,k values, allowing you to see the performance over a range of matrix sizes. This test takes up the most time, so it is recommended to skip it when running the guide for the first time. 

### 2. Microbenchmark - NCCL Bandwidth

The [NCCL bandwidth test](https://github.com/Azure/AI-benchmarking-guide/blob/main/Benchmarks/NCCLBandwidth.py) is a benchmark provided by NVIDIA's NCCL (NVIDIA Collective Communications Library) library. NCCL is a high-performance library, designed to accelerate interGPU communication, that optimizes communication between multiple GPUs within a single node or across multiple nodes in a multi-GPU system. 
The performance measured is the data transfer bandwidth between GPUs using various communication patterns, such as point-to-point (pairwise) communication or collective communication (communication between multiple GPUs). 

### 3. Microbenchmark - HBM Bandwidth
[High Bandwidth Memory](https://github.com/Azure/AI-benchmarking-guide/blob/main/Benchmarks/HBMBandwidth.py) (HBM) is designed to provide a significant boost in memory bandwidth for GPUs by handling vast amounts of data through vertical stacking of multiple layers of memory chips, connected by through-silicon vias. 

### 4. Microbenchmark - NV Bandwidth
The [NV Bandwidth](https://github.com/Azure/AI-benchmarking-guide/blob/main/Benchmarks/NVBandwidth.py) benchmark measures the bandwidth achieved while transferring packets CPU-to-GPU and GPU-to-CPU over PCIe, and GPU-to-GPU over NVLink. 

### 5. Microbenchmark - Flash Attention
[FlashAttention](https://github.com/Azure/AI-benchmarking-guide/blob/main/Benchmarks/FlashAttention.py) is an algorithm to speed up attention and reduce the memory footprint for Natural Language Models—without any approximation. It is meant to speed up training and inference by reordering the attention computation and leveraging classical techniques (tiling, recomputation) to reduce memory usage from quadratic to linear in sequence length. 

### 6. End-to-end Inference Workloads
To assess how different system components (as tested by the microbenchmarks) affect overall performance, we suggetsing running some [end-to-end workloads](https://github.com/Azure/AI-benchmarking-guide/blob/main/Benchmarks/LLMBenchmark.py). The models we used for benchmarking are the current industry standards across various sizes: Mistral (7B parameters), LLAMA 3 (8B, 70B, and 405B). The performance of the model inferencing (throughput) is measured in tokens per second, accounting for both processing input tokens and generating output tokens. The workloads run in a TensorRT-LLM environment. Users need huggingface credentials to download all the model weigths. Visit [huggingface.co](https://huggingface.co/) to create an account and obtain access to the models. After obtaining your credentials, add them [here](https://github.com/Azure/AI-benchmarking-guide/blob/02d2875b8051d357bd5a871bee6fb7104b631908/config.json#L47)

## How to run the benchmarking guide

### Requirements
All the requirements for the benchmarks can be intalled with a simple command: `bash install_requirements.sh`. This will install the Python PIP, NCCL, and Docker packages needed. 
#### Build LLMBench container
```
#Build image from scratch
make -C Benchmarks/TensorRT-LLM-img fetch build
# Create image's tar archive, will be saved to Benchmark/tensorrt-llm-12.4.0-devel-ubuntu22.04.tar.zst
make -C Benchmarks/TensorRT-LLM-img fetch build tar-img
# Load container image from saved archive
zstdcat tensorrt-llm-12.4.0-devel-ubuntu22.04.tar.zst | docker load

```
### Runs
The Azure AI Benchmarking Guide runs all the benchmarks described above with the command: `python3 runner.py`. The file [`config.json`](https://github.com/Azure/AI-benchmarking-guide/blob/main/config.json) contains the specific settings for the benchmarks.
To run specific microbenchmarks, see  [`runner.py`](https://github.com/Azure/AI-benchmarking-guide/blob/02d2875b8051d357bd5a871bee6fb7104b631908/runner.py#L104) and comment out the tests you are not interested in running. The [`models`](https://github.com/Azure/AI-benchmarking-guide/blob/02d2875b8051d357bd5a871bee6fb7104b631908/config.json#L52) field in `config.json` contains all the end-to-end models that can be benchmarked. To run benchmark for a specific model, set `use_model: true`. They are all set to `false` by default.
Test results will be stored in the `Outputs` directory. 

You can find example of results for the ND A100 v4, ND H100 v5 and ND H200 v5 virtual machines stored under [`Azure_Results`](https://github.com/Azure/AI-benchmarking-guide/tree/main/Azure_Results).
