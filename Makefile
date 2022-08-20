.PHONY: build test-run test-stop

IMAGE_NAME = kevinnls/sshd

build:
	# building the image as ${IMAGE_NAME}
	docker buildx build -t $(IMAGE_NAME) src/

test-run:
	docker run --name sshd --detach --rm --publish 8022:8022 ${IMAGE_NAME}
	docker logs -f sshd
test-stop:
	docker stop sshd
