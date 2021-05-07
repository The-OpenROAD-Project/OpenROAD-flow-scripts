pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
  }
  options {
    timeout(time: 2, unit: 'HOURS');
  }
  stages {
    stage('Build') {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1;
      }
      steps {
        sh './build_openroad.sh --local';
        stash name: 'build', includes: "tools/build/**";
      }
    }
    stage('Test') {
      parallel {
        stage('nangate45 aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh aes nangate45';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('nangate45 gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh gcd nangate45';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('nangate45 ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh ibex nangate45';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('nangate45 tiny rocket') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh tinyRocket nangate45';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('sky130 hd aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh aes sky130hd';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('sky130 hd gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh gcd sky130hd';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('sky130 hd ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh ibex sky130hd';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('sky130 hs aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh aes sky130hs';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('sky130 hs gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh gcd sky130hs';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
        stage('sky130 hs ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'flow/test/test_helper.sh ibex sky130hs';
          }
          post {
            always {
              archiveArtifacts artifacts: 'flow/reports/**/*';
            }
          }
        }
      }
    }
  }
  post {
    failure {
      script {
        if ( env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'openroad' ) {
          echo('Main development branch: report to stakeholders and commit author.');
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
          REPLY_TO="$EMAIL_TO";
        } else {
          echo('Feature development branch: report only to commit author.');
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL";
          REPLY_TO='$DEFAULT_REPLYTO';
        }
        sh './flow/util/getMetricsErrors.sh 2>&1 | tee error-list.txt';
        emailext (
            to: "$EMAIL_TO",
            replyTo: "$REPLY_TO",
            subject: '$DEFAULT_SUBJECT',
            body: '$DEFAULT_CONTENT',
            )
      }
    }
  }
}
