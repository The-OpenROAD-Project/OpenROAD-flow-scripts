pipeline {
  agent any
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim()
  }
  options {
    disableConcurrentBuilds()
    timeout(time: 8, unit: 'HOURS')
  }
  stages {
    stage('Build') {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1
      }
      steps {
        sh './build_openroad.sh --local'
      }
    }
    stage('Test') {
      parallel {
        stage('nangate45_aes') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh aes nangate45"'
          }
        }
        stage('nangate45_gcd') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"'
          }
        }
        stage('nangate45_tinyRocket') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh tinyRocket nangate45"'
          }
        }
        stage('sky130_hs_gcd') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd SKY130HS"'
          }
        }
        stage('sky130_hs_aes') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh aes SKY130HS"'
          }
        }
        stage('sky130_hd_gcd') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd SKY130HD"'
          }
        }
        stage('sky130_hd_aes') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh aes SKY130HD"'
          }
        }
      }
    }
  }
  post {
    always {
      archiveArtifacts artifacts: 'flow/reports/**/*'
    }
    failure {
      script {
        if ( env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'openroad' ) {
          echo('Main development branch: report to stakeholders and commit author.')
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS"
          REPLY_TO="$EMAIL_TO"
        } else {
          echo('Feature development branch: report only to commit author.')
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL"
          REPLY_TO='$DEFAULT_REPLYTO'
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
