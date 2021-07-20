pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
    MAKE_ISSUE = 1;
  }
  options {
    timeout(time: 4, unit: "HOURS");
  }
  stages {
    stage("Checkout master branch") {
      steps {
        checkout([$class: "GitSCM",
              branches: [[name: "*/master"]],
              doGenerateSubmoduleConfigurations: false,
              extensions: [
                [
                  $class: "SubmoduleOption",
                  disableSubmodules: false,
                  parentCredentials: true,
                  recursiveSubmodules: true,
                  reference: "",
                  trackingSubmodules: false
                ],
                [
                  $class: "RelativeTargetDirectory",
                  relativeTargetDir: "tools/OpenROAD"
                ]
              ],
              submoduleCfg: [],
              userRemoteConfigs: [
                [
                credentialsId: "openroad-ci",
                url: "https://github.com/The-OpenROAD-Project/OpenROAD"
                ]
              ]
            ])
      }
    }
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
        stage("Docker") {
          agent any;
          steps {
            sh "./build_openroad.sh";
            sh 'docker run -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow-scripts/flow/platforms:ro openroad/flow-scripts flow/test/test_helper.sh';
          }
        }
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
        stage("asap7 ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex asap7";
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
        stage("asap7 jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg asap7";
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
        stage("nangate45 black_parrot") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh black_parrot nangate45";
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
        stage("nangate45 bp_multi_top") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh bp_multi_top nangate45";
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
        stage("nangate45 swerv") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh swerv nangate45";
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
        stage("nangate45 swerv_wrapper") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh swerv_wrapper nangate45";
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
        stage("sky130hd chameleon") {
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
        sh "./flow/util/getMetricsErrors.sh 2>&1 | tee error-list.txt";
        emailext (
            to: '$DEFAULT_RECIPIENTS',
            replyTo: '$DEFAULT_REPLYTO',
            subject: '$DEFAULT_SUBJECT',
            body: '$DEFAULT_CONTENT',
            )
      }
    }
  }
}
