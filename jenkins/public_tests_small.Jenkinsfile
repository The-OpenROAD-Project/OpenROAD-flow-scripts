node {
  def MAKE_ISSUE = 1

  properties([
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME),
  ]);

  stage('Checkout'){
    checkout scm
  }

  def isChanged = false
  stage('Build and Push Docker Image') {
    if (isDependencyInstallerChanged(env.BRANCH_NAME)) {
      def commitHash = sh(script: 'git rev-parse HEAD', returnStdout: true)
      commitHash = commitHash.replaceAll(/[^a-zA-Z0-9-]/, '')

      isChanged = true
      DOCKER_IMAGE_TAG = pushCIImage(env.BRANCH_NAME, commitHash)
    }
  }

  try {
    docker.image("openroad/flow-ubuntu22.04-dev:${DOCKER_IMAGE_TAG}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
      sh "git config --system --add safe.directory '*'"
      stage('Local Build') {
        localBuild()
      }
    }

    stage('Tests') {
      Map tasks = [failFast: false]
      if(isChanged) {
          Map matrix_axes_1 = [
          OS: ['ubuntu20.04']
          ]
          def axes_1 = matrix_axes_1.OS

          for (axisValue in axes_1) {
              def currentOS = axisValue
              tasks["${currentOS}"] = {
                  node {
                    docker.image("openroad/flow-ubuntu22.04-dev:${DOCKER_IMAGE_TAG}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
                        sh "git config --system --add safe.directory '*'"
                        checkout scm
                        testDependencyInstaller(currentOS)
                    }
                  }
                }
          }
      }
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
                      "riscv32i ihp-sg13g2",
                      "delta debug"]
      ]
      def axes = matrix_axes.TEST_SLUG

      for (axisValue in axes) {
          def currentSlug = axisValue
          tasks["${currentSlug}"] = {
              node {
                  docker.image("openroad/flow-ubuntu22.04-dev:${DOCKER_IMAGE_TAG}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
                    sh "git config --system --add safe.directory '*'"
                    checkout scm
                    runTests(currentSlug)
                  }
              }
            }
      }

      parallel(tasks)
    }

    docker.image("openroad/flow-ubuntu22.04-dev:${DOCKER_IMAGE_TAG}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
      sh "git config --system --add safe.directory '*'"
      stage('Report Short Summary') {
        generateReportShortSummary()
      }

      stage("Report Summary") {
        generateReportSummary()
      }

      stage("Report Full") {
        generateReportFull()
      }

      stage("Report HTML Table") {
        generateReportHtmlTable()
      }
    }

  } finally {
    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
        try {
            copyArtifacts filter: "flow/reports/report-summary.log",
                    projectName: "${JOB_NAME}",
                    selector: specific("${BUILD_NUMBER}")

            def COMMIT_AUTHOR_EMAIL = sh(script: "git --no-pager show -s --format='%ae'", returnStdout: true).trim()

            sendEmail(env.BRANCH_NAME, COMMIT_AUTHOR_EMAIL, '''
                      $DEFAULT_CONTENT
                      ${FILE, path="flow/reports/report-summary.log"}
                  ''')
        } catch (Exception e) {
            echo "Exception occurred: ${e.toString()}"
            EMAIL_TO = "\$DEFAULT_RECIPIENTS"
        }
    }
  }
}
