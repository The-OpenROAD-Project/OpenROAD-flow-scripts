#!/bin/tcsh
cp ${SCRIPTS_DIR}/DREAMPlace_ref.json ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_tech_lef_xx@${TECH_LEF}@" ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_sc_lef_xx@${SC_LEF}@" ${RESULTS_DIR}/DREAMPlace.json
cp ${RESULTS_DIR}/3_2_place_iop.def ${RESULTS_DIR}/2_DREAMPlace_input.def
sed -i "/+ PORT/d" ${RESULTS_DIR}/2_DREAMPlace_input.def
sed -i "s@xx_input_def_xx@${RESULTS_DIR}/2_DREAMPlace_input.def@" ${RESULTS_DIR}/DREAMPlace.json
sed -i "s@xx_result_dir_xx@${RESULTS_DIR}@" ${RESULTS_DIR}/DREAMPlace.json

set isNumber = `echo "${PLACE_DENSITY}" | grep -E '[0-9,\.]+' | wc -l`

# If place density is set to some value then only it sets that
if ( $isNumber == 1 ) then
    sed -i "s@xx_place_density_xx@${PLACE_DENSITY}@" ${RESULTS_DIR}/DREAMPlace.json
else
    sed -i "/xx_place_density_xx/d" ${RESULTS_DIR}/DREAMPlace.json
endif

set additional_lefs = ""
set dq = '"'
foreach additional_lef (`echo "${ADDITIONAL_LEFS}"`)
    set additional_lefs = "${additional_lefs},${dq}${additional_lef}${dq}"
end
set design_list = ""

sed -i "s@xx_additional_lef_xx@$additional_lefs@" ${RESULTS_DIR}/DREAMPlace.json

set host_name = `hostname`
if ( $host_name == "xxx.xxx.xxx" ) then
    set isGpu = "1"
else
    set isGpu = "0"
endif

sed -i "s@xx_isGpu_xx@${isGpu}@" ${RESULTS_DIR}/DREAMPlace.json
