pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh label: 'Build', script: './build_openroad.sh'
      }
    }
      
    stage('Test') {
      parallel {
        stage('nangate45_gcd') {
          steps {
            catchError {
              sh label: 'nangate45_gcd', script: '''#!/bin/bash
source setup_env.sh
cd flow && test/test_helper.sh gcd nangate45'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_aes') {
          steps {
            catchError {
              sh label: 'nangate45_aes', script: '''#!/bin/bash
source setup_env.sh
cd flow && test/test_helper.sh aes nangate45'''
            }
            echo currentBuild.result
          }
        }
      }
    }
  }
}
