pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
  }
  options {
    timeout(time: 4, unit: 'HOURS');
  }
  stages {
    stage('Build') {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1;
      }
      steps {
        sh './build_openroad.sh --local --or_branch master';
        stash name: 'build', includes: "tools/build/**";
      }
    }
    stage('Test') {
      parallel {
        stage('Docker') {
          agent any;
          steps {
            sh './build_openroad.sh';
            sh 'docker run -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow-scripts/flow/platforms:ro openroad/flow-scripts bash -c "source setup_env.sh && flow/test/test_helper.sh"';
          }
        }
        stage('asap7 aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh aes asap7"';
            stash name: 'asap7_aes', includes: 'flow/reports/**/*';
          }
        }
        stage('asap7 gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh gcd asap7"';
            stash name: 'asap7_gcd', includes: 'flow/reports/**/*';
          }
        }
        stage('asap7 ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh ibex asap7"';
            stash name: 'asap7_ibex', includes: 'flow/reports/**/*';
          }
        }
        stage('asap7 jpeg') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh jpeg asap7"';
            stash name: 'asap7_jpeg', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh aes nangate45"';
            stash name: 'nangate45_aes', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 black_parrot') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh black_parrot nangate45"';
            stash name: 'nangate45_black_parrot', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 bp_be_top') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh bp_be_top nangate45"';
            stash name: 'nangate45_bp_be_top', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 bp_fe_top') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh bp_fe_top nangate45"';
            stash name: 'nangate45_bp_fe_top', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 bp_multi_top') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh bp_multi_top nangate45"';
            stash name: 'nangate45_bp_multi_top', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 dynamic_node') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh dynamic_node nangate45"';
            stash name: 'nangate45_dynamic_node', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh gcd nangate45"';
            stash name: 'nangate45_gcd', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh ibex nangate45"';
            stash name: 'nangate45_ibex', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 jpeg') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh jpeg nangate45"';
            stash name: 'nangate45_jpeg', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 opensparc_t1') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh opensparc_t1 nangate45"';
            stash name: 'nangate45_opensparc_t1', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 swerv') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh swerv nangate45"';
            stash name: 'nangate45_swerv', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 swerv_wrapper') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh swerv_wrapper nangate45"';
            stash name: 'nangate45_swerv_wrapper', includes: 'flow/reports/**/*';
          }
        }
        stage('nangate45 tiny rocket') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh tinyRocket nangate45"';
            stash name: 'nangate45_tinyRocket', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh aes sky130hd"';
            stash name: 'sky130_hd_aes', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130hd chameleon') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh chameleon sky130hd"';
            stash name: 'sky130_hd_chameleon', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130hd coyote_tc') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh coyote_tc sky130hd"';
            stash name: 'sky130_hd_coyote_tc', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh gcd sky130hd"';
            stash name: 'sky130_hd_gcd', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh ibex sky130hd"';
            stash name: 'sky130_hd_ibex', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd jpeg') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh jpeg sky130hd"';
            stash name: 'sky130_hd_jpeg', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs aes') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh aes sky130hs"';
            stash name: 'sky130_hs_aes', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130hs coyote_tc') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh coyote_tc sky130hs"';
            stash name: 'sky130_hs_coyote_tc', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs gcd') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh gcd sky130hs"';
            stash name: 'sky130_hs_gcd', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs ibex') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh ibex sky130hs"';
            stash name: 'sky130_hs_ibex', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs jpeg') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh jpeg sky130hs"';
            stash name: 'sky130_hs_jpeg', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd aes_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh aes sky130hd config_ppa.mk ppa"';
            stash name: 'sky130_hd_aes_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd gcd_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh gcd sky130hd config_ppa.mk ppa"';
            stash name: 'sky130_hd_gcd_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd ibex_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh ibex sky130hd config_ppa.mk ppa"';
            stash name: 'sky130_hd_ibex_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hd jpeg_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh jpeg sky130hd config_ppa.mk ppa"';
            stash name: 'sky130_hd_jpeg_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs aes_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh aes sky130hs config_ppa.mk ppa"';
            stash name: 'sky130_hs_aes_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs gcd_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh gcd sky130hs config_ppa.mk ppa"';
            stash name: 'sky130_hs_gcd_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs ibex_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh ibex sky130hs config_ppa.mk ppa"';
            stash name: 'sky130_hs_ibex_ppa', includes: 'flow/reports/**/*';
          }
        }
        stage('sky130 hs jpeg_ppa') {
          agent any;
          steps {
            unstash 'build';
            sh 'bash -ic "source setup_env.sh && flow/test/test_helper.sh jpeg sky130hs config_ppa.mk ppa"';
            stash name: 'sky130_hs_jpeg_ppa', includes: 'flow/reports/**/*';
          }
        }
      }
    }
  }
  post {
    always {
      unstash 'asap7_aes';
      unstash 'asap7_gcd';
      unstash 'asap7_ibex';
      unstash 'asap7_jpeg';
      unstash 'nangate45_aes';
      unstash 'nangate45_black_parrot';
      unstash 'nangate45_bp_be_top';
      unstash 'nangate45_bp_fe_top';
      unstash 'nangate45_bp_multi_top';
      unstash 'nangate45_dynamic_node';
      unstash 'nangate45_gcd';
      unstash 'nangate45_ibex';
      unstash 'nangate45_jpeg';
      unstash 'nangate45_opensparc_t1';
      unstash 'nangate45_swerv';
      unstash 'nangate45_swerv_wrapper';
      unstash 'nangate45_tinyRocket';
      unstash 'sky130_hd_aes';
      unstash 'sky130_hd_chameleon';
      unstash 'sky130_hd_coyote_tc';
      unstash 'sky130_hd_gcd';
      unstash 'sky130_hd_ibex';
      unstash 'sky130_hd_jpeg';
      unstash 'sky130_hs_aes';
      unstash 'sky130_hs_coyote_tc';
      unstash 'sky130_hs_gcd';
      unstash 'sky130_hs_ibex';
      unstash 'sky130_hs_jpeg';
      unstash 'sky130_hd_aes_ppa';
      unstash 'sky130_hd_gcd_ppa';
      unstash 'sky130_hd_ibex_ppa';
      unstash 'sky130_hd_jpeg_ppa';
      unstash 'sky130_hs_aes_ppa';
      unstash 'sky130_hs_gcd_ppa';
      unstash 'sky130_hs_ibex_ppa';
      unstash 'sky130_hs_jpeg_ppa';
      archiveArtifacts artifacts: 'flow/reports/**/*';
    }
    failure {
      script {
        if ( env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'openroad' ) {
          echo('Main development branch: report to stakeholders and commit author.');
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
          REPLY_TO="$EMAIL_TO";
        } else {
          echo('Feature development branch: report only to commit author.');
          EMAIL_TO="$COMMIT_AUTHOR_EMAIL";
          REPLY_TO='$DEFAULT_REPLYTO';
        }
        sh './flow/util/getMetricsErrors.sh 2>&1 | tee error-list.txt';
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
