pipeline {
  agent any;
  environment {
    MAKE_ISSUE = 1;
  }
  options {
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME);
  }
  stages {

    stage('Local Build') {
      agent any;
      steps {
        sh "./build_openroad.sh --local";
        stash name: "install", includes: "tools/install/**";
      }
      post {
        always {
          catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
            archiveArtifacts artifacts: "build_openroad.log";
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
                   "mock-cpu asap7",
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
          stage('Test') {
            options {
              timeout(time: 6, unit: "HOURS");
            }
            agent any;
            steps {
              unstash "install";
              script {
                stage("${TEST_SLUG}") {
                  catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    if ("${TEST_SLUG}" == 'docker build'){
                      retry(3) {
                        try {
                          sh "./build_openroad.sh --no_init";
                        }
                        catch (e) {
                          sleep(60);
                          sh 'exit 1';
                        }
                      }
                      sh "docker run --rm openroad/flow-centos7-builder:latest tools/install/OpenROAD/bin/openroad -help -exit";
                      sh "docker run --rm openroad/flow-centos7-builder:latest bash -c 'source ./env.sh ; make -C flow'";
                    } else {
                      sh 'nice flow/test/test_helper.sh ${TEST_SLUG}';
                    }
                  }
                }
              }
            }
            post {
              always {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                  archiveArtifacts artifacts: "flow/*tar.gz", allowEmptyArchive: true, excludes: "**/4_eqy_output/**";
                  archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*", allowEmptyArchive: true, excludes: "**/4_eqy_output/**";
                }
              }
            }
          }
        }
      }
    }

    stage("Report Short Summary") {
      steps {
        copyArtifacts filter: "flow/logs/**/*",
                      projectName: '${JOB_NAME}',
                      selector: specific('${BUILD_NUMBER}');
        copyArtifacts filter: "flow/reports/**/*",
                      projectName: '${JOB_NAME}',
                      selector: specific('${BUILD_NUMBER}');
        sh "flow/util/genReport.py -sv";
      }
      post {
        always {
          archiveArtifacts artifacts: "flow/reports/report-summary.log";
          archiveArtifacts artifacts: "flow/reports/**/report*.log";
        }
      }
    }

    stage("Report Summary") {
      steps {
        sh "flow/util/genReport.py -svv";
      }
    }

    stage("Report Full") {
      steps {
        sh "flow/util/genReport.py -vvvv";
      }
    }

    stage("Report HTML Table") {
      steps {
        sh "flow/util/genReportTable.py";
        publishHTML([
            allowMissing: true,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportName: "Report",
            reportDir: "flow/reports",
            reportFiles: "report-table.html,report-gallery*.html",
            reportTitles: "Flow Report"
        ]);
      }
    }

  }

  post {
    failure {
      copyArtifacts filter: "flow/reports/report-summary.log",
                    projectName: '${JOB_NAME}',
                    selector: specific('${BUILD_NUMBER}');
      script {
        try {
          COMMIT_AUTHOR_EMAIL = sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
          if ( env.BRANCH_NAME == "master" ) {
            echo("Main development branch: report to stakeholders and commit author.");
            EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
          } else {
            echo("Feature development branch: report only to commit author.");
            EMAIL_TO="$COMMIT_AUTHOR_EMAIL";
          }
        } catch (Exception e) {
          echo "Exception occurred: " + e.toString();
          EMAIL_TO="\$DEFAULT_RECIPIENTS";
        }
        emailext (
            to: "$EMAIL_TO",
            replyTo: "$EMAIL_TO",
            subject: '$DEFAULT_SUBJECT',
            body: '''
$DEFAULT_CONTENT
${FILE,path="flow/reports/report-summary.log"}
            ''',
            )
      }
    }
  }

}
