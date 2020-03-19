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
        stage('nangate45_aes') {
          steps {
            catchError {
              sh label: 'nangate45_aes', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh aes nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_black_parrot') {
          steps {
            catchError {
              sh label: 'nangate45_black_parrot', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh black_parrot nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_bp_be_top') {
          steps {
            catchError {
              sh label: 'nangate45_bp_be_top', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh bp_be_top nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_bp_fe_top') {
          steps {
            catchError {
              sh label: 'nangate45_bp_fe_top', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh bp_fe_top nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_bp_multi_top') {
          steps {
            catchError {
              sh label: 'nangate45_bp_multi_top', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh bp_multi_top nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_dynamic_node') {
          steps {
            catchError {
              sh label: 'nangate45_dynamic_node', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh dynamic_node nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_gcd') {
          steps {
            catchError {
              sh label: 'nangate45_gcd', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh gcd nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_ibex') {
          steps {
            catchError {
              sh label: 'nangate45_ibex', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh ibex nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_jpeg') {
          steps {
            catchError {
              sh label: 'nangate45_jpeg', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh jpeg nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_swerv') {
          steps {
            catchError {
              sh label: 'nangate45_swerv', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh swerv nangate45"'''
            }
            echo currentBuild.result
          }
        }
        stage('nangate45_swerv_wrapper') {
          steps {
            catchError {
              sh label: 'nangate45_swerv_wrapper', script: '''
              docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow bash -c "source setup_env.sh && cd flow && test/test_helper.sh swerv_wrapper nangate45"'''
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
