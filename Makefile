OPENROAD_MODULES = yosys ioPlacer tapcell TritonCTS FastRoute4-lefdef TritonMacroPlace pdn TritonRoute

clone_all: $(addprefix clone_,$(OPENROAD_MODULES))
	@

clone_%:
	if ! [ -d src/$* ]; then \
		git clone --recursive git@github.com:The-OpenROAD-Project/$*.git src/$*; \
	fi

docker_all: $(addprefix docker_,$(OPENROAD_MODULES))
	@

docker_%: clone_%
	docker build -t openroad/$(shell echo $* | tr A-Z a-z) -f src/$*/Dockerfile src/$*


build_all: $(addprefix build/src/,$(OPENROAD_MODULES))
	@

#build/src/%: 
build/src/%: docker_%
	rm -rf ./$@
	container_id=$$(docker create openroad/$(shell echo $* | tr A-Z a-z)) && \
	docker cp $$container_id:/build $@ && \
	docker rm -v $$container_id

