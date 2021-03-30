#!/usr/bin/env bash

/home/tool/gnu/parallel/parallel-20160822/bin/parallel --joblog out.log --bar --env GRB_LICENSE_FILE --env LD_LIBRARY_PATH --env PATH --env LM_LICENSE_FILE --sshloginfile node --workdir $PWD < run.sh
