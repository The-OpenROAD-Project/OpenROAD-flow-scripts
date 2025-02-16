include .env
export

BASE_TAG=$(shell cd ../../../ && ./etc/DockerTag.sh -dev)
ORFS_IMAGE := openroad/orfs:v3.0-2422-g3dc9e665  # update manually (do not use latest)
ORFS_AUTOTUNER_IMAGE := orfs-autotuner

.PHONY: init
init:
	@echo "Setting up environment..."
	@../installer.sh

.PHONY: clean
clean:
	@echo "Cleaning up old images"
	@docker rmi ${ORFS_AUTOTUNER_IMAGE}:latest || true

.PHONY: docker
docker: clean
	@echo "Building docker image..."
	@docker build -t ${ORFS_AUTOTUNER_IMAGE}:latest -f Dockerfile --build-arg BASE_IMAGE=${ORFS_IMAGE} .. | tee docker-build.log
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

.PHONY: up
up:
	@echo "Starting Ray cluster..."
	@ray disable-usage-stats
	@ray up -y public.yaml

.PHONY: down
down:
	@echo "Stopping Ray cluster..."
	@ray down -y public.yaml

.PHONY: dashboard
dashboard:
	@echo "Starting Ray dashboard..."
	@ray dashboard public.yaml

.PHONY: monitor
monitor:
	@echo "Monitoring Ray cluster..."
	@ray monitor public.yaml
