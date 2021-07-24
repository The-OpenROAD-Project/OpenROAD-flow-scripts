pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
    MAKE_ISSUE = 1;
  }
  options {
    timeout(time: 1, unit: "HOURS");
  }
  stages {
    stage("Build") {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1;
      }
      steps {
        sh "./build_openroad.sh --local";
        stash name: "install", includes: "tools/install/**";
      }
    }
    stage("Test") {
      parallel {
        stage("asap7 aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes asap7";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd asap7";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 bp_be_top") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh bp_be_top nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 bp_fe_top") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh bp_fe_top nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 dynamic_node") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh dynamic_node nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 tiny rocket") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh tinyRocket nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes sky130hd";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd chameleon") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh chameleon sky130hd";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd sky130hd";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex sky130hd";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg sky130hd";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes sky130hs";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd sky130hs";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex sky130hs";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg sky130hs";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
            }
            failure {
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
      }
    }
  }
  post {
    failure {
      script {
        if ( env.BRANCH_NAME == "master" ) {
          echo("Main development branch: report to stakeholders and commit author.");
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
          REPLY_TO="$EMAIL_TO";
        } else {
          echo("Feature development branch: report only to commit author.");
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL";
          REPLY_TO='$DEFAULT_REPLYTO';
        }
        sh "./flow/util/getMetricsErrors.sh 2>&1 | tee error-list.txt";
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
