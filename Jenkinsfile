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
      matrix {
        axes {
          axis {
            name 'PLATFORM'
            values 'nangate45'
          }
          axis {
            name 'DESIGN'
            values 'gcd', 'aes', 'tinyRocket'
          }
        }
        stages {
          stage("${PLATFORM}_${DESIGN}") {
            steps {
              sh label: "${PLATFORM}_${DESIGN}", script: "flow/jenkins/run_test.sh ${DESIGN} ${PLATFORM}"
            }
          }
        }
      }
    }
  }
}
