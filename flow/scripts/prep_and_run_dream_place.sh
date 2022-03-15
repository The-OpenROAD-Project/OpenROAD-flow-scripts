#!/bin/tcsh
cp ${SCRIPTS_DIR}/DREAMPlace_ref.json ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_tech_lef_xx@${TECH_LEF}@" ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_sc_lef_xx@${SC_LEF}@" ${RESULTS_DIR}/DREAMPlace.json
cp ${RESULTS_DIR}/3_2_place_iop.def ${RESULTS_DIR}/2_DREAMPlace_input.def
sed -i "/+ PORT/d" ${RESULTS_DIR}/2_DREAMPlace_input.def
sed -i "s@xx_input_def_xx@${RESULTS_DIR}/2_DREAMPlace_input.def@" ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_result_dir_xx@${RESULTS_DIR}@" ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_place_density_xx@${PLACE_DENSITY}@" ${RESULTS_DIR}/DREAMPlace.json

set host_name = `hostname`
if ( $host_name == "dfm.ucsd.edu" ) then
    set isGpu = "1"
else
    set isGpu = "0"
endif

sed -i "s@xx_isGpu_xx@${isGpu}@" ${RESULTS_DIR}/DREAMPlace.json

/home/zf4_projects/Chaos/OR/DREAMPlace/envs/DREAMG/bin/python3.7 /home/zf4_projects/Chaos/OR/DREAMPlace/GPU/DREAMPlace/install/dreamplace/Placer.py ${RESULTS_DIR}/DREAMPlace.json

cp ${RESULTS_DIR}/2_DREAMPlace_input/2_DREAMPlace_input.gp.def ${RESULTS_DIR}/3_3_place_gp.def
