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
cd flow && make DESIGN_CONFIG=designs/nangate45/gcd.mk'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_aes') {
          steps {
            catchError {
              sh label: 'nangate45_aes', script: '''#!/bin/bash
source setup_env.sh
cd flow && make DESIGN_CONFIG=designs/nangate45/aes.mk all'''
            }
            echo currentBuild.result
          }
        }
      }
    }
  }
}
