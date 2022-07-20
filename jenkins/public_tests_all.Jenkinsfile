pipeline {
  agent any;
  environment {
    MAKE_ISSUE = 1;
  }
  options {
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME);
  }
  stages {

    stage("Build") {
      steps {
        script {
          parallel(
            "LOCAL": {
              sh "./build_openroad.sh --local --no_init";
              stash name: "install", includes: "tools/install/**";
            },
            "DOCKER": {
              sh "./build_openroad.sh";
              sh 'docker run -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow-scripts/flow/platforms:ro openroad/flow-scripts flow/test/test_helper.sh';
            }
          );
        }
      }
    }

    stage('Tests') {
      matrix {
        axes {
          axis {
            name 'TEST_SLUG';
            values "aes asap7",
                   "ethmac asap7",
                   "gcd asap7",
                   "ibex asap7",
                   "jpeg asap7",
                   "sha3 asap7",
                   "uart asap7",
                   "aes nangate45",
                   "black_parrot nangate45",
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
                   "chameleon_hier sky130hd",
                   "gcd sky130hd",
                   "ibex sky130hd",
                   "jpeg sky130hd",
                   "microwatt sky130hd",
                   "riscv32i sky130hd",
                   "aes sky130hs",
                   "gcd sky130hs",
                   "ibex sky130hs",
                   "jpeg sky130hs",
                   "riscv32i sky130hs";
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
                    sh 'nice flow/test/test_helper.sh ${TEST_SLUG}';
                  }
                }
              }
            }
            post {
              always {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                  archiveArtifacts artifacts: "flow/*tar.gz";
                  archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
                }
              }
            }
          }
        }
      }
    }

    stage("Reports") {
      steps {
        copyArtifacts filter: "flow/logs/**/*",
                      projectName: '${JOB_NAME}',
                      selector: specific('${BUILD_NUMBER}');
        copyArtifacts filter: "flow/reports/**/*",
                      projectName: '${JOB_NAME}',
                      selector: specific('${BUILD_NUMBER}');
        script {
          parallel(
            "Full report": { sh "flow/util/genReport.py -vv ; flow/util/genReport.py -s"; },
            "HTML Report": {
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
          );
        }
      }
    }

  }

  post {
    failure {
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
