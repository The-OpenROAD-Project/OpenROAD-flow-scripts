# -*- coding: utf-8 -*-
#
# Copyright 2020 Regents of the University of California
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

MACRO_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOP_DIR := $(realpath $(MACRO_DIR)/..)

include $(TOP_DIR)/openram.mk

.DEFAULT_GOAL := all

CONFIG_DIR = configs
OUT_DIR = .
TECH = sky130

SRCS=$(filter-out disabled-% %_common.py,$(sort $(notdir $(wildcard $(CONFIG_DIR)/*.py))))
DIRS=$(basename $(SRCS))
STAMPS=$(addsuffix .ok,$(DIRS))

BROKEN := \
	sky130_sram_1kbyte_1r1w_8x1024_8 \
	sky130_sram_1kbyte_1rw_32x256_8 \
	sky130_sram_2kbyte_1rw_32x512_8 \
	sky130_sram_4kbyte_1rw_32x1024_8 \
	sky130_sram_1kbyte_1rw1r_32x256_8 \
	sky130_sram_2kbyte_1rw1r_32x512_8 \
	sky130_sram_4kbyte_1rw1r_32x1024_8

WORKING_STAMPS=$(filter-out $(addsuffix .ok,$(BROKEN)),$(STAMPS))

all: | $(OPENRAM_COMPILER)
	$(MAKE) configs
	@echo
	@echo "Building following working configs"
	@for S in $(WORKING_STAMPS); do echo " - $$S"; done
	@sleep 5
	$(MAKE) $(WORKING_STAMPS)
	@echo "Built all macros."

OPTS =

# Define `OPENRAM_FULL` in your environment to run a full characterize and
# perform DRC/LVS.
ifeq ($(OPENRAM_FULL),)
# Do not characterize or perform DRC/LVS
OPTS += -n
else
# Characterize and perform DRC/LVS
OPTS += -c
endif

# Verbosity
OPTS += -v

SHELL ?= /usr/bin/env bash
export SHELL
export SHELLOPTS := pipefail

%.ok: configs/%.py | $(OPENRAM_COMPILER) $(SKY130_FD_PR)
	@mkdir -p $*
	python3 -u $(OPENRAM_COMPILER) $(OPTS) -p $* -o $* $<
	touch $@

.DELETE_ON_ERROR: $(STAMPS)

$(DIRS):
	@$(MAKE) --no-print-directory $@.ok

.PHONY: $(DIRS)

clean:
	rm -rf $(STAMPS)
	rm -rf $(DIRS)

.PHONY: clean

configs: | $(OPENRAM_COMPILER) $(SKY130_FD_PR)
	@echo
	@echo "Using OpenRAM at $(OPENRAM_HOME) (from $(OPENRAM_SRC))"
	@echo " (which is version $$(cd $(OPENRAM_HOME); git describe --tags))"
	@echo
	@echo "Using SkyWater primitives at $(SKY130_FD_PR) (from $(SKY130_FD_PR_SRC))"
	@echo " (which is version $$(cd $(SKY130_FD_PR); git describe --tags))"
	@echo
	@echo "Configurations:"
	@for D in $(DIRS); do echo " - $$D"; done
	@echo

.PHONY: configs

update-gitignore:
	rm .gitignore; touch .gitignore
	for L in $(STAMPS); do echo $$L; done >> .gitignore
	for D in $(DIRS); do echo $$D; done >> .gitignore

.PHONY: update-gitignore
