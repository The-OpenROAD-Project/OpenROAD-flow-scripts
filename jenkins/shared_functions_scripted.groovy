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
    try {
        timeout(time: 6, unit: "HOURS") {
            node {
            unstash "install"
            catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                if (testSlug == 'docker build') {
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
                sh "nice flow/test/test_helper.sh ${testSlug}"
                }
            }
            }
        }
        }
        finally {
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
            archiveArtifacts artifacts: "flow/*tar.gz", allowEmptyArchive: true, excludes: "**/4_eqy_output/**"
            archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*", allowEmptyArchive: true, excludes: "**/4_eqy_output/**"
        }
    }
}

def generateReportShortSummary() {
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

def generateReportSummary() {
    sh "flow/util/genReport.py -svv"
}

def generateReportFull() {
    sh "flow/util/genReport.py -vvvv";
}

def generateReportHtmlTable() {
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

def uploadMetadata(branchname, commitsha) {
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

return this