def sharedFunctions = load 'shared_functions.groovy'

pipeline {
    agent any
    environment {
        MAKE_ISSUE = 1
    }
    options {
        copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME)
    }

    stages {
      stage('Local Build') {
        agent any;
        steps {
          script{
            sharedFunctions.localBuild()
          }
        }
        post {
            always {
                script {
                  sharedFunctions.postBuildLocalBuild()
                }
            }
        }
      }

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
            stage('Run Tests') {
                steps {
                  script{
                    sharedFunctions.runTests("${TEST_SLUG}")
                  }  
                }
                post {
                    always {
                      script{
                        sharedFunctions.postBuildRunTests("${TEST_SLUG}")
                      } 
                    }
                }
            }
        }
        }
      }

      stage("Report Short Summary") {
          steps {
            script {
              sharedFunctions.generateReportShortSummary()
            }
          }
          post {
            always {
              script {
                shared_functions.postBuildReportShortSummary("Report Short Summary")
              }
            }
          }
      }

      stage("Report Summary") {
        steps {
          script {
            shared_functions.generateReportSummary()
          }
        }
      }

      stage("Report Full") {
        steps {
          script {
            sharedFunctions.generateReportFull()
          }
        }
      }

      stage("Report HTML Table") {
        steps {
          script {
            sharedFunctions.generateReportHtmlTable()
          }
        }
      }   

      stage('Upload Metadata') {
        steps {
          script {
            sharedFunctions.uploadMetadata(${env.BRANCH_NAME}, ${env.BRANCH_NAME})
          }
        }
      }   
      
    }

    post {
        failure {
            script {
                sharedFunctions.handleFailurePostBuild()
            }
        }
    }
}
