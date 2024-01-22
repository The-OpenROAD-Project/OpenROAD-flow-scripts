@Library('utils@main') _

node {
  def MAKE_ISSUE = 1

  properties([
    copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME),
  ]);

  stage('Checkout'){
      // checkout changelog: false, poll: false, scm: [
      //     $class: 'GitSCM',
      //     branches: [[name: "refs/pull/${env.BRANCH_NAME}/head"]],
      //     doGenerateSubmoduleConfigurations: false,
      //     extensions: [
      //     [
      //         $class: 'SubmoduleOption', 
      //         disableSubmodules: false, 
      //         parentCredentials: true, 
      //         recursiveSubmodules: true, 
      //         reference: '', 
      //         trackingSubmodules: false
      //     ],
      //     [
      //       $class: "RelativeTargetDirectory",
      //       relativeTargetDir: "tools/OpenROAD"
      //     ]
      //     ],
      //     submoduleCfg: [],
      // ]
      checkout scm
      def changedFiles = []
      for ( changeLogSet in currentBuild.changeSets){
          for (entry in changeLogSet.getItems()){
              changedFiles.addAll(entry.affectedPaths)
          }
      }
      sh "echo ${changedFiles}"
  }

  // def shared_functions = load("./jenkins/shared_functions_scripted.groovy")
  def DOCKER_IMAGE_TAG = "latest"
  stage('Build and Push Docker Image') {
    // Check if it's a commit tag
    if (isCommitTag(env.BRANCH_NAME)) {
      echo "Building & Pushing Docker image for ubuntu22.04"
      withCredentials([usernamePassword(credentialsId: 'docker', dockerUsername: 'USERNAME', dockerPassword: 'PASSWORD')]) {
        sh "./etc/DockerHelper.sh pushCI -os=ubuntu22.04 -target=dev -sha -username=${USERNAME} -password=${PASSWORD}"
      }
      DOCKER_IMAGE_TAG = env.GIT_COMMIT
    } else {
      echo "No changes using latest tag"
    }
  }
  
  docker.image("openroad/flow-ubuntu22.04-dev:${DOCKER_IMAGE_TAG}").inside {
    try {
      properties([
        copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME),
      ]);

      stage('Checkout'){
        checkout changelog: false, poll: false, scm: [
            $class: 'GitSCM',
            branches: [[name: "refs/pull/${env.BRANCH_NAME}/head"]],
            doGenerateSubmoduleConfigurations: false,
            extensions: [
            [
                $class: 'SubmoduleOption',
                disableSubmodules: false, 
                parentCredentials: true, 
                recursiveSubmodules: true, 
                reference: '', 
                trackingSubmodules: false
            ],
            [
              $class: "RelativeTargetDirectory",
              relativeTargetDir: "tools/OpenROAD"
            ]
            ],
            submoduleCfg: [], 
        ]
      }
      
      stage('Local Build') {
        localBuild()
      }

      if(DOCKER_IMAGE_TAG != "latest") {
        stage('Test Dependency Installer') {
          Map matrix_axes = [
          OS: ['ubuntu20.04', 'ubuntu22.04', 'centos7']
          ]
          def axes = matrix_axes.OS

          Map tasks = [failFast: false]
          for (axisValue in axes) {
              def currentOS = axisValue
              tasks["${currentOS}"] = {
                  node {
                      checkout scm
                      testDependencyInstaller(currentOS)
                  }
                }
          }

          parallel(tasks)
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
        def axes = matrix_axes.TEST_SLUG

        Map tasks = [failFast: false]
        for (axisValue in axes) {
            def currentSlug = axisValue
            tasks["${currentSlug}"] = {
                node {
                    checkout scm
                    runTests(currentSlug)
                }
              }
        }

        parallel(tasks)
      }

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

      stage('Upload Metadata') {
        uploadMetadata(env.BRANCH_NAME, env.GIT_COMMIT)
      }

    } finally {
      catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
          try {
              copyArtifacts filter: "flow/reports/report-summary.log",
                      projectName: "${JOB_NAME}",
                      selector: specific("${BUILD_NUMBER}")

              def COMMIT_AUTHOR_EMAIL = sh(script: "git --no-pager show -s --format='%ae'", returnStdout: true).trim()
              // def EMAIL_TO = emailDetails(env.BRANCH_NAME, COMMIT_AUTHOR_EMAIL)

              // if (env.BRANCH_NAME == "master") {
              //     echo("Main development branch: report to stakeholders and commit author.")
              //     EMAIL_TO = "${COMMIT_AUTHOR_EMAIL}, \$DEFAULT_RECIPIENTS"
              // } else {
              //     echo("Feature development branch: report only to commit author.")
              //     EMAIL_TO = "${COMMIT_AUTHOR_EMAIL}"
              // }
              sendEmail(env.BRANCH_NAME, COMMIT_AUTHOR_EMAIL, '''
                      $DEFAULT_CONTENT
                      ${FILE, path="flow/reports/report-summary.log"}
                  ''')

              // emailext (
              //     to: "$EMAIL_TO",
              //     replyTo: "$EMAIL_TO",
              //     subject: '$DEFAULT_SUBJECT',
              //     body: '''
              //         $DEFAULT_CONTENT
              //         ${FILE, path="flow/reports/report-summary.log"}
              //     '''
              // )
          } catch (Exception e) {
              echo "Exception occurred: ${e.toString()}"
              EMAIL_TO = "\$DEFAULT_RECIPIENTS"
          }
      }
    } 
    
    }
}