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

def uploadMetadata(Stirng branchname, String commitsha) {
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
        withCredentials([file(credentialsId: 'firebase-admin-svc', variable: 'db_cred')]) {
            sh """
                python3 flow/util/uploadMetadata.py \
                --buildID ${env.BUILD_ID} \
                --branchName $branchname \
                --commitSHA $commitsha \
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

// def isCommitTag(String branchName) {
//     if (changeset ["**/etc/DependencyInstaller.sh", "**/etc/DockerHelper.sh", "**/.github/workflows/github-actions-cron-test-installer.yml", "**/build_openroad.sh", "**/env.sh", "**/flow/Makefile"]) {
//         return true
//     } else if (${branchName} == 'master') {
//         return false
//     } else {
//         return true
//     }
// }

def isCommitTag(branchName) {
    def changedFiles = script {
        return changelog(['--format=%s'])
    }

    if (changedFiles.any { it.contains("etc/DependencyInstaller.sh") || it.contains("etc/DockerHelper.sh") || it.contains(".github/workflows/github-actions-cron-test-installer.yml") || it.contains("build_openroad.sh") || it.contains("env.sh") || it.contains("flow/Makefile") }) {
        return true
    } else if (branchName == 'master') {
        return false
    } else {
        return true
    }
}

def emailDetails(String branchName, String COMMIT_AUTHOR_EMAIL) {
    def EMAIL_TO
    if (env.BRANCH_NAME == "master") {
        echo("Main development branch: report to stakeholders and commit author.")
        EMAIL_TO = "$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS"
    } else if (env.BRANCH_NAME == "nightly") {
        echo("Nightly run: report to stakeholders and commit author.");
        EMAIL_TO="$COMMIT_AUTHOR_EMAIL, \$DEFAULT_RECIPIENTS";
    }
    else {
        echo("Feature development branch: report only to commit author.")
        EMAIL_TO = "$COMMIT_AUTHOR_EMAIL"
    }
    return $EMAIL_TO
}

// function to check if current build is from master, has logic --> set tag to be latest or commit based on changes in installer script
// DONE: function should include email target list for different branches

return this