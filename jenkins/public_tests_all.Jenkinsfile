pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
    MAKE_ISSUE = 1;
  }
  options {
    timeout(time: 4, unit: "HOURS");
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME);
  }
  stages {
    stage ('BuildAndTest') {
        matrix {
          agent any;
          axes {
              axis {
                name 'TEST'
                values 'aes asap7', 
                'ethmac asap7', 
                'gcd asap7', 
                'ibex asap7', 
                'jpeg asap7', 
                'sha3 asap7', 
                'uart asap7', 
                'aes nangate45', 
                'black_parrot nangate45', 
                'bp_be_top nangate45', 
                'bp_fe_top nangate45', 
                'bp_multi_top nangate45', 
                'dynamic_node nangate45', 
                'gcd nangate45', 
                'ibex nangate45', 
                'jpeg nangate45',
                'swerv nangate45', 
                'swerv_wrapper nangate45', 
                'tinyRocket nangate45', 
                'aes sky130hd', 
                'chameleon sky130hd', 
                'gcd sky130hd', 
                'ibex sky130hd', 
                'jpeg sky130hd', 
                'microwatt sky130hd', 
                'riscv32i sky130hd', 
                'aes sky130hs', 
                'gcd sky130hs', 
                'ibex sky130hs', 
                'jpeg sky130hs', 
                'riscv32i sky130hs';
              }
          }
          stages{
            stage("Build") {
              environment {
                OPENROAD_FLOW_NO_GIT_INIT = 1;
              }
              steps {
                sh "./build_openroad.sh --local";
                stash name: "install", includes: "tools/install/**";
              }
            }
            stage("Docker") {
              agent any;
              steps {
                sh "./build_openroad.sh";
                sh 'docker run -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow-scripts/flow/platforms:ro openroad/flow-scripts flow/test/test_helper.sh';
              }
            }
            stage("axis") {
              agent none;
              steps {
                script{
                  stage("${TEST}") {
                    print "${TEST}"
                  }
                }
              }
            }
            stage ("Test") {
              agent any;
              steps {
                  unstash "install";
                  sh "flow/test/test_helper.sh ${TEST}";
              }
              post {
                always {
                  archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
                  archiveArtifacts artifacts: "flow/*tar.gz";
                }
              }
            }
          }
        }
      }
    }
  
  post {
    always {
      copyArtifacts filter: "flow/logs/**/*",
                    projectName: '${JOB_NAME}',
                    selector: specific('${BUILD_NUMBER}');
      copyArtifacts filter: "flow/reports/**/*",
                    projectName: '${JOB_NAME}',
                    selector: specific('${BUILD_NUMBER}');
      sh "flow/util/genReport.py -vv --single --file --no-print";
      sh "flow/util/genReportTable.py";
      sh "flow/util/genReport.py -vvv --file --no-print";
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
    failure {
      script {
        try {
          COMMIT_AUTHOR_EMAIL = sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
          if ( env.BRANCH_NAME == "master" ) {
            echo("Main development branch: report to stakeholders and commit author.");
            EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
            REPLY_TO="$EMAIL_TO";
          } else {
            echo("Feature development branch: report only to commit author.");
            EMAIL_TO="$COMMIT_AUTHOR_EMAIL";
            REPLY_TO='$DEFAULT_REPLYTO';
          }
        } catch (Exception e) {
          echo "Exception occurred: " + e.toString();
          EMAIL_TO="\$DEFAULT_RECIPIENTS";
          REPLY_TO='$DEFAULT_REPLYTO';
        }
        emailext (
            to: "$EMAIL_TO",
            replyTo: "$REPLY_TO",
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
