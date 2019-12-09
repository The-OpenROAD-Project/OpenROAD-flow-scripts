OPENROAD_MODULES = yosys tapcell TritonCTS TritonMacroPlace pdn TritonRoute
SRC_PATH = OpenROAD/src
BUILD_PATH = OpenROAD/build/src
clone_all: $(addprefix clone_,$(OPENROAD_MODULES))
	@

clone_%:
	if ! [ -d $(SRC_PATH)/$* ]; then \
		git clone --recursive git@github.com:The-OpenROAD-Project/$*.git $(SRC_PATH)/$*; \
	fi

docker_all: $(addprefix docker_,$(OPENROAD_MODULES))
	@

docker_%: clone_%
	docker build -t openroad/$(shell echo $* | tr A-Z a-z) -f $(SRC_PATH)/$*/Dockerfile $(SRC_PATH)/$*

build_all: $(addprefix $(BUILD_PATH)/,$(OPENROAD_MODULES))
	@

$(BUILD_PATH)/%: docker_%
	mkdir -p $(BUILD_PATH)
	rm -rf ./$@
	container_id=$$(docker create openroad/$(shell echo $* | tr A-Z a-z)) && \
	docker cp $$container_id:/build $@ && \
	docker rm -v $$container_id

