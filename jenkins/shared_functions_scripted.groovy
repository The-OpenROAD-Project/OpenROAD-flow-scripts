// Defing shared functions to be used by different pipelines

def localBuild(options = "--local") {
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

def runTests(testSlug) {
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

def uploadMetadata(branchname, commitsha) {
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

def isMasterBranch(branchName) {
    return branchName == 'master'
} 

def geTag(branchName) {
    if (changeset ["**/etc/DependencyInstaller.sh", "**/etc/DockerHelper.sh", "**/.github/workflows/github-actions-cron-test-installer.yml", "**/build_openroad.sh", "**/env.sh", "**/flow/Makefile"]) {
        return "-sha"
    } else if (branchName == 'master') {
        return ""
    } else {
        return "-sha"
    }
}

def emailDetails(branchName) {
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

return this