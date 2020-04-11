pipeline {
  agent any

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
            catchError {
              sh label: 'nangate45_gcd', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_aes') {
          steps {
            catchError {
              sh label: 'nangate45_aes', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh aes nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_tinyRocket') {
          steps {
            catchError {
              sh label: 'nangate45_tinyRocket', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh tinyRocket nangate45"'''
            }
            echo currentBuild.result
          }
        }
      }
    }
  }
}
