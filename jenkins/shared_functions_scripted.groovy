// Defing shared functions to be used by different pipelines

def localBuild(String options = "--local") {
    try {
        sh "ls"
        sh "./build_openroad.sh $options"
        stash name: "install", includes: "tools/install/**"
    } catch (Exception ex) {
        currentBuild.result = 'FAILURE'
        throw ex
    } finally {
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
            archiveArtifacts artifacts: "build_openroad.log"
        }
    }
}

def runTests(String currentSlug) {
    try {
        unstash "install"
        timeout(time: 6, unit: "HOURS") {
            catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                if ("${currentSlug}" == 'docker build') {
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
                echo "${currentSlug}"
                sh "nice flow/test/test_helper.sh ${currentSlug}"
                }
            }
        }
    } finally {
    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
        archiveArtifacts artifacts: "flow/*tar.gz", allowEmptyArchive: true, excludes: "**/4_eqy_output/**"
        archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*", allowEmptyArchive: true, excludes: "**/4_eqy_output/**"
    }
    }
}

def generateReportShortSummary() {
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
        try {
        copyArtifacts filter: "flow/logs/**/*",
                        projectName: '${JOB_NAME}',
                        selector: specific('${BUILD_NUMBER}')
        copyArtifacts filter: "flow/reports/**/*",
                        projectName: '${JOB_NAME}',
                        selector: specific('${BUILD_NUMBER}')
        sh "flow/util/genReport.py -sv"
        } finally {
        archiveArtifacts artifacts: "flow/reports/report-summary.log"
        archiveArtifacts artifacts: "flow/reports/**/report*.log"
        }
    }
}

def generateReportSummary() {
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
        sh "flow/util/genReport.py -svv"
    }
}

def generateReportFull() {
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
        sh "flow/util/genReport.py -vvvv"
    }
}

def generateReportHtmlTable() {
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
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
    }
}

def uploadMetadata(String branchName, String commitSha) {
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
        withCredentials([file(credentialsId: 'firebase-admin-svc', variable: 'db_cred')]) {
            sh """
                python3 flow/util/uploadMetadata.py \
                --buildID ${env.BUILD_ID} \
                --branchName $branchName \
                --commitSHA $commitSha \
                --jenkinsURL ${env.RUN_DISPLAY_URL} \
                --pipelineID ${env.BUILD_TAG} \
                --changeBranch ${env.CHANGE_BRANCH} \
            """ + '--cred ${db_cred}'
        }
    }
}

def isMasterBranch(String branchName) {
    return ${branchName} == 'master'
}

def isDependencyInstallerChanged(String branchName) {
    def local_branch = sh(
        script: "git rev-parse --abbrev-ref HEAD",
        label: "Getting current branch name",
        returnStdout: true
    ).trim()
    println "Local branch is ${local_branch}"

    def base_branch = 'master'
    println "Base branch is ${base_branch}"

    sh script: "git fetch origin --no-tags ${base_branch}", label: "Getting base branch"
    sh script:"git checkout origin/${base_branch}"

    def git_diff = sh(
        script: "git diff --name-only origin/${base_branch}..${local_branch}",
        returnStdout: true
    ).trim()

    if (git_diff.contains("etc/DependencyInstaller.sh") || git_diff.contains("etc/DockerHelper.sh") || git_diff.contains(".github/workflows/github-actions-cron-test-installer.yml") || git_diff.contains("build_openroad.sh") || git_diff.contains("env.sh") || git_diff.contains("flow/Makefile")) {
        return true
    } else {
        return false
    }
}

def isCommitTag(String branchName) {
    if (isDependencyInstallerChanged(branchName) || branchName != 'master') {
        return true
    } else {
        return false
    }
}

def emailDetails(String branchName, String COMMIT_AUTHOR_EMAIL) {
    def EMAIL_TO
    if (branchName == "master") {
        echo("Main development branch: report to stakeholders and commit author.")
        EMAIL_TO = "$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS"
    } else if (branchName == "nightly") {
        echo("Nightly run: report to stakeholders and commit author.")
        EMAIL_TO = "$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS"
    } else {
        echo("Feature development branch: report only to commit author.")
        EMAIL_TO = "$COMMIT_AUTHOR_EMAIL"
    }
    return EMAIL_TO
}

def testDependencyInstaller(os) {
    // def osList = ['ubuntu20.04', 'ubuntu22.04', 'centos7']
    // for (int i = 0; i < osList.size(); i++) {
        // def os = osList[i]
    echo "Building & Testing Docker image for OS: ${os}"
    def options = ""
    // if(isCommitTag == true) {
    //     options = "-sha"
    // }
    sh "./etc/DockerHelper.sh create -os=${os} -target=dev"
    sh "./etc/DockerHelper.sh create -os=${os} -target=builder"
    def cmd = """
        yosys -help
        openroad -help
        make -C flow
    """

    if (os == "centos7") {
        cmd = """
            source /opt/rh/devtoolset-8/enable
            source /opt/rh/llvm-toolset-7.0/enable
            source /opt/rh/rh-python38/enable
            ${cmd}
        """
    }
    sh "docker run openroad/flow-${os}-builder /bin/bash -c "${cmd}""
    // }
}

// function to check if current build is from master, has logic --> set tag to be latest or commit based on changes in installer script
// DONE: function should include email target list for different branches

return this