include .env
export

BASE_TAG=$(shell cd ../../ && ./etc/DockerTag.sh -dev)
ORFS_IMAGE := openroad/orfs:latest
ORFS_AUTOTUNER_IMAGE := orfs-autotuner

.PHONY: clean
clean:
	@echo "Cleaning up old images"
	@docker rmi ${ORFS_AUTOTUNER_IMAGE}:latest || true

.PHONY: docker
docker: clean
	@echo "Building docker image..."
	@docker build -t ${ORFS_AUTOTUNER_IMAGE}:latest -f Dockerfile --build-arg BASE_IMAGE=${ORFS_IMAGE} . | tee docker-build.log
	@docker tag ${ORFS_AUTOTUNER_IMAGE}:latest ${ORFS_AUTOTUNER_IMAGE}:$(BASE_TAG)

.PHONY: upload
upload: docker
	@echo "Uploading docker image..."
	@docker login -u $(DOCKERHUB_USERNAME) -p $(DOCKERHUB_PASSWORD)
	@echo "Base image: $(BASE_TAG)"
	@docker tag ${ORFS_AUTOTUNER_IMAGE}:latest ${DOCKERHUB_USERNAME}/${ORFS_AUTOTUNER_IMAGE}:$(BASE_TAG)
	@docker tag ${ORFS_AUTOTUNER_IMAGE}:latest ${DOCKERHUB_USERNAME}/${ORFS_AUTOTUNER_IMAGE}:latest
	@docker push ${DOCKERHUB_USERNAME}/${ORFS_AUTOTUNER_IMAGE}:$(BASE_TAG)
	@docker push ${DOCKERHUB_USERNAME}/${ORFS_AUTOTUNER_IMAGE}:latest
	@docker logout
