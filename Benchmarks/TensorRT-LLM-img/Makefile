IMAGE_BASE_NAME ?= cuda
IMAGE_NAME ?= tensorrt-llm
IMAGE_BASE_REPO=nvidia/
IMAGE_BASE_TAG  ?= 12.4.0-devel-ubuntu22.04
MODEL_LIST ?= "llama"
TAG =${IMAGE_BASE_TAG}

# podman:// or dockerd://
CT_RUNTIME ?= dockerd://
EXPORT_PATH ?= ..
ZSTD_COMPRESS_OPTIONS ?= --ultra -22


fetch:
	docker pull "${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}"

build:
	docker build --network=host --progress plain --rm \
		--tag "${IMAGE_NAME}:${TAG}" \
		--build-arg IMAGE_BASE="${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}" \
		--build-arg  MODEL_LIST="${MODEL_LIST}" \
		-f Dockerfile .

tar-img:
	docker save \
		"${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}" \
		"${IMAGE_NAME}:${TAG}" | \
		zstdmt ${ZSTD_COMPRESS_OPTIONS} -v -f -o ${EXPORT_PATH}/${IMAGE_NAME}-${TAG}.tar.zst
