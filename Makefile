.PHONY: build

IMAGE_NAME = kevinnls/sshd

build:
	# building the image as ${IMAGE_NAME}

	docker buildx build -t $(IMAGE_NAME) src/

