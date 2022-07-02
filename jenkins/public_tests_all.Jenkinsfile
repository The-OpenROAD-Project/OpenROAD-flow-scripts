pipeline {
  agent any;
  environment {
    COMMIT_AUTHOR_EMAIL= sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
    MAKE_ISSUE = 1;
  }
  options {
    timeout(time: 4, unit: "HOURS");
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME);
  }
  stages {
    stage("Build") {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1;
      }
      steps {
        sh "./build_openroad.sh --local";
        stash name: "install", includes: "tools/install/**";
      }
    }
    stage("Test") {
      parallel {
        stage("Docker") {
          agent any;
          steps {
            sh "./build_openroad.sh";
            sh 'docker run -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow-scripts/flow/platforms:ro openroad/flow-scripts flow/test/test_helper.sh';
          }
        }
        stage("asap7 aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes asap7";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_aes_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_final_report_aes_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 ethmac") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ethmac asap7";
          }
          post {
           success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_ethmac_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_ethmac_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd asap7";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_gcd_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_gcd_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex asap7";
          }
          post {
           success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_ibex_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_ibex_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg asap7";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_jpeg_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_jpeg_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 sha3") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh sha3 asap7";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_sha3_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_sha3_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("asap7 uart") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh uart asap7";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_uart_asap7*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_uart_asap7*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_aes_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_aes_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 black_parrot") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh black_parrot nangate45";
          }
          post {
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 bp_be_top") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh bp_be_top nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_bp_be_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_bp_be_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 bp_fe_top") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh bp_fe_top nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_bp_fe_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_bp_fe_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 bp_multi_top") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh bp_multi_top nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_bp_multi_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_bp_multi_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 dynamic_node") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh dynamic_node nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_dynamic_node_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_dynamic_node_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_gcd_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_gcd_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_ibex_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_ibex_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_jpeg_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_jpeg_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 swerv") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh swerv nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_swerv_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_swerv_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 swerv_wrapper") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh swerv_wrapper nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_swerv_wrapper_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_swerv_wrapper_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("nangate45 tiny rocket") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh tinyRocket nangate45";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_tinyRocket_nangate45*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_tinyRocket_nangate45*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_aes_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_aes_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd chameleon") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh chameleon sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_chameleon_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_chameleon_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_gcd_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_gcd_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_ibex_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_ibex_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_jpeg_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_jpeg_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd microwatt") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh microwatt sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_microwatt_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_microwatt_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hd riscv32i") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh riscv32i sky130hd";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_riscv32i_sky130hd*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_riscv32i_sky130hd*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs aes") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh aes sky130hs";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_aes_sky130hs*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_aes_sky130hs*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs gcd") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh gcd sky130hs";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_gcd_sky130hs*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_gcd_sky130hs*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs ibex") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh ibex sky130hs";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_ibex_sky130hs*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_ibex_sky130hs*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs jpeg") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh jpeg sky130hs";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_jpeg_sky130hs*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_jpeg_sky130hs*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
        stage("sky130 hs riscv32i") {
          agent any;
          steps {
            unstash "install";
            sh "flow/test/test_helper.sh riscv32i sky130hs";
          }
          post {
            success {
              sh "mkdir -p flow/success";
              sh "mv flow/final_report_riscv32i_sky130hs*tar.gz flow/success";
            }
            failure {
              sh "mkdir -p flow/failure";
              sh "mv flow/final_report_riscv32i_sky130hs*tar.gz flow/failure";
            }
            always {
              archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*";
              archiveArtifacts artifacts: "flow/*tar.gz";
            }
          }
        }
      }
    }
  }
  post {
    always {
      copyArtifacts filter: "flow/logs/**/*",
                    projectName: '${JOB_NAME}',
                    selector: specific('${BUILD_NUMBER}');
      copyArtifacts filter: "flow/reports/**/*",
                    projectName: '${JOB_NAME}',
                    selector: specific('${BUILD_NUMBER}');
      sh "flow/util/genReport.py -vv --single --file --no-print";
      sh "flow/util/genReportTable.py";
      sh "flow/util/genReport.py -vvv --file --no-print";
      publishHTML([
          allowMissing: true,
          alwaysLinkToLastBuild: true,
          keepAll: true,
          reportName: "Report",
          reportDir: "flow/reports",
          reportFiles: "report-table.html,report-gallery*.html",
          reportTitles: "Flow Report"
      ]);
    }
    failure {
      script {
        try {
          COMMIT_AUTHOR_EMAIL = sh (returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim();
          if ( env.BRANCH_NAME == "master" ) {
            echo("Main development branch: report to stakeholders and commit author.");
            EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
            REPLY_TO="$EMAIL_TO";
          } else {
            echo("Feature development branch: report only to commit author.");
            EMAIL_TO="$COMMIT_AUTHOR_EMAIL";
            REPLY_TO='$DEFAULT_REPLYTO';
          }
        } catch (Exception e) {
          echo "Exception occurred: " + e.toString();
          EMAIL_TO="\$DEFAULT_RECIPIENTS";
          REPLY_TO='$DEFAULT_REPLYTO';
        }
        emailext (
            to: "$EMAIL_TO",
            replyTo: "$REPLY_TO",
            subject: '$DEFAULT_SUBJECT',
            body: '''
$DEFAULT_CONTENT
${FILE,path="flow/reports/report-summary.log"}
            ''',
            )
      }
    }
  }
}
