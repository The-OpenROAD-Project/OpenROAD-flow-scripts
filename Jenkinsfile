pipeline {
  agent any
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim()
  }
  stages {
    stage('Build') {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1
      }
      steps {
        sh label: 'Build', script: './build_openroad.sh'
      }
    }
    stage('Test') {
      failFast true
      parallel {
        stage('nangate45_gcd') {
          steps {
            sh label: 'nangate45_gcd', script: '''
            docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"'''
          }
        }
        stage('nangate45_aes') {
          steps {
            sh label: 'nangate45_aes', script: '''
            docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh aes nangate45"'''
          }
        }
        stage('nangate45_tinyRocket') {
          steps {
            sh label: 'nangate45_tinyRocket', script: '''
            docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh tinyRocket nangate45"'''
          }
        }
      }
    }
  }
  post {
    failure {
      script {
        if ( env.BRANCH_NAME == 'openroad' ) {
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
