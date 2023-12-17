def sharedFunctions = load 'shared_functions.groovy'

pipeline {
    agent any
    environment {
        MAKE_ISSUE = 1
    }
    options {
        copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME)
    }

    sharedFunctions.localBuild()

    stage('Tests') {
      matrix {
        axes {
          axis {
            name 'TEST_SLUG';
            values "docker build",
                   "aes asap7",
                   "aes-mbff asap7",
                   "aes_lvt asap7",
                   "ethmac asap7",
                   "ethmac_lvt asap7",
                   "gcd asap7",
                   "ibex asap7",
                   "jpeg asap7",
                   "jpeg_lvt asap7",
                   "riscv32i asap7",
                   "uart asap7",
                   "mock-array asap7",
                   "mock-alu asap7",
                   "aes-block asap7",
                   "aes nangate45",
                   "bp_be_top nangate45",
                   "bp_fe_top nangate45",
                   "bp_multi_top nangate45",
                   "dynamic_node nangate45",
                   "gcd nangate45",
                   "ibex nangate45",
                   "jpeg nangate45",
                   "swerv nangate45",
                   "swerv_wrapper nangate45",
                   "tinyRocket nangate45",
                   "aes sky130hd",
                   "chameleon sky130hd",
                   "gcd sky130hd",
                   "ibex sky130hd",
                   "jpeg sky130hd",
                   "microwatt sky130hd",
                   "riscv32i sky130hd",
                   "aes sky130hs",
                   "gcd sky130hs",
                   "ibex sky130hs",
                   "jpeg sky130hs",
                   "riscv32i sky130hs",
                   "aes gf180",
                   "aes-hybrid gf180",
                   "ibex gf180",
                   "jpeg gf180",
                   "riscv32i gf180",
                   "uart-blocks gf180",
                   "aes ihp-sg13g2",
                   "ibex ihp-sg13g2",
                   "gcd ihp-sg13g2",
                   "spi ihp-sg13g2",
                   "riscv32i ihp-sg13g2";
          }
        }

        stages {
            sharedFunctions.runTests("${TEST_SLUG}")
        }
      }
    }

    sharedFunctions.generateReportShortSummary()
    sharedFunctions.generateReportSummary()
    sharedFunctions.generateReportFull()
    sharedFunctions.generateReportHtmlTable()
    
    sharedFunctions.handleFailurePostBuild()
}
