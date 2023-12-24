node {
  def MAKE_ISSUE = 1

  // def jobOptions = [
  //   [$class: 'CopyArtifactPermission', project: "${JOB_NAME},${env.BRANCH_NAME}"]
  // ]

  // copyArtifacts(projectName: '${JOB_NAME},'+env.BRANCH_NAME)

  // checkout([$class: 'GitSCM', 
  //           branches: [[name: 'refs/heads/${env.BRANCH_NAME}']], 
  //           userRemoteConfigs: scm.userRemoteConfigs])

  properties([
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME),
  ]);

  // def shared_functions = load("shared_functions_scripted.groovy")

  stage('Checkout'){
    checkout scm
  }

  // stage('Build and Push Docker Image') {
  //   //if not master push to tagged commit
  //   if (changeset ["**/etc/DependencyInstaller.sh", "**/etc/DockerHelper.sh", "**/.github/workflows/github-actions-cron-test-installer.yml", "**/build_openroad.sh", "**/env.sh", "**/flow/Makefile"]) {
  //     def osList = ['ubuntu20.04', 'ubuntu22.04', 'centos7']
  //     for (int i = 0; i < osList.size(); i++) {
  //       def os = osList[i]
  //       echo "Building Docker image for OS: ${os}"
  //       sh "./etc/DockerHelper.sh create -target=dev -os=${os}"
  //       sh "./etc/DockerHelper.sh push -target=dev -os=${os}" // add tag to be the commit tag
  //     }
  //   }
  // }
  // function to check if current build is from master, has logic --> set tag to be latest or commit based on changes in installer script
  // function should include email target list for different branches
  // docker.image('openroad/flow-ubuntu22.04-dev').inside {
    try {
      stage('Local Build') {
        // node {
          // checkout scm
          try {
              sh "ls"
              sh "./build_openroad.sh --local"
              stash name: "install", includes: "tools/install/**"
          } catch (Exception ex) {
              currentBuild.result = 'FAILURE'
              throw ex
          } finally {
              catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                  archiveArtifacts artifacts: "build_openroad.log"
              }
          // }
          // shared_functions_scripted.localBuild()
        }
      }

      stage('Tests') {
        Map matrix_axes = [
        TEST_SLUG: ["docker build",
                        "aes asap7",
                        "aes-mbff asap7",
                        "aes_lvt asap7",
                        "ethmac asap7",
                        "ethmac_lvt asap7",
                        "gcd asap7",
                        "ibex asap7",
                        "jpeg asap7",
                        "jpeg_lvt asap7",
                        "riscv32i asap7",
                        "uart asap7",
                        "mock-array asap7",
                        "mock-alu asap7",
                        "aes-block asap7",
                        "aes nangate45",
                        "bp_be_top nangate45",
                        "bp_fe_top nangate45",
                        "bp_multi_top nangate45",
                        "dynamic_node nangate45",
                        "gcd nangate45",
                        "ibex nangate45",
                        "jpeg nangate45",
                        "swerv nangate45",
                        "swerv_wrapper nangate45",
                        "tinyRocket nangate45",
                        "aes sky130hd",
                        "chameleon sky130hd",
                        "gcd sky130hd",
                        "ibex sky130hd",
                        "jpeg sky130hd",
                        "microwatt sky130hd",
                        "riscv32i sky130hd",
                        "aes sky130hs",
                        "gcd sky130hs",
                        "ibex sky130hs",
                        "jpeg sky130hs",
                        "riscv32i sky130hs",
                        "aes gf180",
                        "aes-hybrid gf180",
                        "ibex gf180",
                        "jpeg gf180",
                        "riscv32i gf180",
                        "uart-blocks gf180",
                        "aes ihp-sg13g2",
                        "ibex ihp-sg13g2",
                        "gcd ihp-sg13g2",
                        "spi ihp-sg13g2",
                        "riscv32i ihp-sg13g2"]
        ]

        List getMatrixAxes(Map matrix_axes) {
            List axes = []
            matrix_axes.each { axis, values ->
                List axisList = []
                values.each { value ->
                    axisList << [(axis): value]
                }
                axes << axisList
            }
            // calculate cartesian product
            axes.combinations()*.sum()
        }

        List axes = getMatrixAxes(matrix_axes)

        Map tasks = [failFast: false]
        for(int i = 0; i < axes.size(); i++) {
            // convert the Axis into valid values for withEnv step
            Map axis = axes[i]
            List axisEnv = axis.collect { k, v ->
                "${k}=${v}"
            }
            def currentSlug = axis.TEST_SLUG
            tasks["${currentSlug}"] = {
            // tasks[axisEnv.join(', ')] = { ->
                // node {
                    // checkout scm
                    // withEnv(axisEnv) {
                        stage("${TEST_SLUG}") {
                          // try {
                            timeout(time: 6, unit: "HOURS") {
                                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                                  if ("${TEST_SLUG}" == 'docker build') {
                                    retry(3) {
                                      try {
                                        sh "./build_openroad.sh --no_init"
                                      }
                                      catch (e) {
                                        sleep(60)
                                        sh 'exit 1'
                                      }
                                    }
                                    sh "docker run --rm openroad/flow-centos7-builder:latest tools/install/OpenROAD/bin/openroad -help -exit"
                                  } else {
                                    sh 'nice flow/test/test_helper.sh ${TEST_SLUG}'
                                  }
                                }
                            }
                          }
                        // }
                      // }
                    // }
            }
          }

          def flow_files = findFiles(glob: 'flow/*tar.gz')
          def logs_files = findFiles(glob: 'flow/logs/**/*')
          def reports_files = findFiles(glob: 'flow/reports/**/*')

          try{
            unstash "install"
            parallel(tasks)
          } finally {
            catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
              if(flow_files.length > 0) {
                archiveArtifacts artifacts: "flow/*tar.gz", allowEmptyArchive: true, excludes: "**/4_eqy_output/**"
              }
              if(logs_files.length > 0 && reports_files.length > 0) {
                archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*", allowEmptyArchive: true, excludes: "**/4_eqy_output/**"
              }
            }
          }
      }

      stage('Report Short Summary') {
        // checkout scm
        try {
          copyArtifacts filter: "flow/logs/**/*",
                        projectName: '${JOB_NAME}',
                        selector: specific('${BUILD_NUMBER}')
          copyArtifacts filter: "flow/reports/**/*",
                        projectName: '${JOB_NAME}',
                        selector: specific('${BUILD_NUMBER}')
          sh "flow/util/genReport.py -sv"
          // sh "flow/util/genReport.py -svv"
          // sh "flow/util/genReport.py -vvvv"
          // sh "flow/util/genReportTable.py"
          publishHTML([
              allowMissing: true,
              alwaysLinkToLastBuild: true,
              keepAll: true,
              reportName: "Report",
              reportDir: "flow/reports",
              reportFiles: "report-table.html,report-gallery*.html",
              reportTitles: "Flow Report"
          ])
        } finally {
          archiveArtifacts artifacts: "flow/reports/report-summary.log"
          archiveArtifacts artifacts: "flow/reports/**/report*.log"
        }
      }

      stage("Report Summary") {
        // node {
          // checkout scm
        sh "flow/util/genReport.py -svv"
        // }
      }

      stage("Report Full") {
        // node {
          // checkout scm
          sh "flow/util/genReport.py -vvvv"
        // }
      }

      stage("Report HTML Table") {
        // node {
          // checkout scm
          sh "flow/util/genReportTable.py"
          publishHTML([
              allowMissing: true,
              alwaysLinkToLastBuild: true,
              keepAll: true,
              reportName: "Report",
              reportDir: "flow/reports",
              reportFiles: "report-table.html,report-gallery*.html",
              reportTitles: "Flow Report"
          ])
        // }
      }

      stage('Upload Metadata') {
        // node {
          checkout scm
          withCredentials([file(credentialsId: 'firebase-admin-svc', variable: 'db_cred')]) {
            sh """
              python3 flow/util/uploadMetadata.py \
                --buildID ${env.BUILD_ID} \
                --branchName ${env.BRANCH_NAME} \
                --commitSHA ${env.GIT_COMMIT} \
                --jenkinsURL ${env.RUN_DISPLAY_URL} \
                --pipelineID ${env.BUILD_TAG} \
                --changeBranch ${env.CHANGE_BRANCH} \
              """ + '--cred ${db_cred}'
          }
        // }
      }

    } finally {
      catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
          try {
              copyArtifacts filter: "flow/reports/report-summary.log",
                      projectName: "${JOB_NAME}",
                      selector: specific("${BUILD_NUMBER}")

              def COMMIT_AUTHOR_EMAIL = sh(script: "git --no-pager show -s --format='%ae'", returnStdout: true).trim()
              def EMAIL_TO

              if (env.BRANCH_NAME == "master") {
                  echo("Main development branch: report to stakeholders and commit author.")
                  EMAIL_TO = "${COMMIT_AUTHOR_EMAIL}, \$DEFAULT_RECIPIENTS"
              } else {
                  echo("Feature development branch: report only to commit author.")
                  EMAIL_TO = "${COMMIT_AUTHOR_EMAIL}"
              }

              emailext (
                  to: EMAIL_TO,
                  replyTo: EMAIL_TO,
                  subject: '$DEFAULT_SUBJECT',
                  body: '''
                      $DEFAULT_CONTENT
                      ${FILE, path="flow/reports/report-summary.log"}
                  '''
              )
          } catch (Exception e) {
              echo "Exception occurred: ${e.toString()}"
              EMAIL_TO = "\$DEFAULT_RECIPIENTS"
          }
      }
    } 
  }
// }