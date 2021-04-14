pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
  }
  options {
    timeout(time: 1, unit: 'HOURS');
  }
  stages {
    stage('Build') {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1;
      }
      steps {
        sh './build_openroad.sh --local';
        stash name: 'build', includes: 'tools/build/**';
      }
    }
    stage('Test') {
      parallel {
        stage('nangate45 aes') {
          agent any;
          stages {
            stage('nangate45_aes') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh aes nangate45"';
                stash name: 'nangate45_aes', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('nangate45 gcd') {
          agent any;
          stages {
            stage('nangate45_gcd') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"';
                stash name: 'nangate45_gcd', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('nangate45 ibex') {
          agent any;
          stages {
            stage('nangate45_ibex') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh ibex nangate45"';
                stash name: 'nangate45_ibex', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('nangate45 tiny rocket') {
          agent any;
          stages {
            stage('nangate45_tinyRocket') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh tinyRocket nangate45"';
                stash name: 'nangate45_tinyRocket', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('sky130 hd aes') {
          agent any;
          stages {
            stage('sky130_hd_aes') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh aes sky130hd"';
                stash name: 'sky130_hd_aes', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('sky130 hd gcd') {
          agent any;
          stages {
            stage('sky130_hd_gcd') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd sky130hd"';
                stash name: 'sky130_hd_gcd', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('sky130 hd ibex') {
          agent any;
          stages {
            stage('sky130_hd_ibex') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh ibex sky130hd"';
                stash name: 'sky130_hd_ibex', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('sky130 hs aes') {
          agent any;
          stages {
            stage('sky130_hs_aes') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh aes sky130hs"';
                stash name: 'sky130_hs_aes', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('sky130 hs gcd') {
          agent any;
          stages {
            stage('sky130_hs_gcd') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd sky130hs"';
                stash name: 'sky130_hs_gcd', includes: 'flow/reports/**/*';
              }
            }
          }
        }
        stage('sky130 hs ibex') {
          agent any;
          stages {
            stage('sky130_hs_ibex') {
              steps {
                unstash 'build';
                sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh ibex sky130hs"';
                stash name: 'sky130_hs_ibex', includes: 'flow/reports/**/*';
              }
            }
          }
        }
      }
    }
  }
  post {
    always {
      unstash 'nangate45_aes';
      unstash 'nangate45_gcd';
      unstash 'nangate45_ibex';
      unstash 'nangate45_tinyRocket';
      unstash 'sky130_hd_aes';
      unstash 'sky130_hd_gcd';
      unstash 'sky130_hd_ibex';
      unstash 'sky130_hs_aes';
      unstash 'sky130_hs_gcd';
      unstash 'sky130_hs_ibex';
      archiveArtifacts artifacts: 'flow/reports/**/*';
    }
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
