pipeline {
  agent any

  stages {
    stage('Build') {
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
              sh label: '_gcd', script: '''
              docker run -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_aes') {
          steps {
            catchError {
              sh label: '_aes', script: '''
              docker run -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh aes nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_tinyRocket') {
          steps {
            catchError {
              sh label: '_tinyRocket', script: '''
              docker run -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh tinyRocket nangate45"'''
            }
            echo currentBuild.result
          }
        }
      }
    }
  }
}
