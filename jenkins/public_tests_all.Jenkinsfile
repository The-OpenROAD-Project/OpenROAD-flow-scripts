pipeline {
  agent any
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
        stage('nangate45_black_parrot') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh black_parrot nangate45"'
          }
        }
        stage('nangate45_bp_be_top') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh bp_be_top nangate45"'
          }
        }
        stage('nangate45_bp_fe_top') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh bp_fe_top nangate45"'
          }
        }
        stage('nangate45_bp_multi_top') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh bp_multi_top nangate45"'
          }
        }
        stage('nangate45_dynamic_node') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh dynamic_node nangate45"'
          }
        }
        stage('nangate45_gcd') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"'
          }
        }
        stage('nangate45_ibex') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh ibex nangate45"'
          }
        }
        stage('nangate45_jpeg') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh jpeg nangate45"'
          }
        }
        stage('nangate45_swerv') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh swerv nangate45"'
          }
        }
        stage('nangate45_swerv_wrapper') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh swerv_wrapper nangate45"'
          }
        }
        stage('nangate45_tinyRocket') {
          steps {
            sh 'bash -ic "source setup_env.sh && cd flow && test/test_helper.sh tinyRocket nangate45"'
          }
        }
      }
    }
  }
}
