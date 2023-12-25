// Defing shared functions to be used by different pipelines
def isMasterBranch(String branchName) {
    return branchName == 'master'
} 

def geTag(String branchName) {
    if (changeset ["**/etc/DependencyInstaller.sh", "**/etc/DockerHelper.sh", "**/.github/workflows/github-actions-cron-test-installer.yml", "**/build_openroad.sh", "**/env.sh", "**/flow/Makefile"]) {
        return "-sha"
    } else if (branchName == 'master') {
        return ""
    } else {
        return "-sha"
    }
}

def checkoutMaster() {
    checkout([$class: "GitSCM",
        branches: [[name: "*/master"]],
        doGenerateSubmoduleConfigurations: false,
        extensions: [
        [
            $class: "SubmoduleOption",
            disableSubmodules: false,
            parentCredentials: true,
            recursiveSubmodules: true,
            reference: "",
            trackingSubmodules: false
        ],
        [
            $class: "RelativeTargetDirectory",
            relativeTargetDir: "tools/OpenROAD"
        ]
        ]
    ])
}

def localBuild(options = "--local") {
    echo "Executing localBuild..."
    sh "./build_openroad.sh $options"
    stash name: "install", includes: "tools/install/**"
}

def postBuildFailure(stageName) {
    echo "Handling Failure in Post Build for stage: ${stageName}..."
    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
        archiveArtifacts artifacts: "build_openroad.log";
    }
}

def runTests(testSlug) {
    echo "Running tests for ${testSlug}..."
    unstash "install"
    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
        if (testSlug == 'docker build') {
            retry(3) {
                try {
                    sh "./build_openroad.sh --no_init"
                } catch (e) {
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

def postBuildRunTests(stageName) {
    echo "Handling Failure in Post Build for stage: ${stageName}..."
    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
        archiveArtifacts artifacts: "flow/*tar.gz", allowEmptyArchive: true, excludes: "**/4_eqy_output/**";
        archiveArtifacts artifacts: "flow/logs/**/*, flow/reports/**/*", allowEmptyArchive: true, excludes: "**/4_eqy_output/**";
    }
}

def generateReportShortSummary() {
    copyArtifacts filter: "flow/logs/**/*",
                        projectName: '${JOB_NAME}',
                        selector: specific('${BUILD_NUMBER}');
    copyArtifacts filter: "flow/reports/**/*",
                        projectName: '${JOB_NAME}',
                        selector: specific('${BUILD_NUMBER}');
    sh "flow/util/genReport.py -sv";
}

def postBuildReportShortSummary(stageName) {
    echo "Handling Failure in Post Build for stage: ${stageName}..."
    archiveArtifacts artifacts: "flow/reports/report-summary.log"
    archiveArtifacts artifacts: "flow/reports/**/report*.log"
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

def handleFailurePostBuild() {
    copyArtifacts filter: "flow/reports/report-summary.log",
                    projectName: '${JOB_NAME}',
                    selector: specific('${BUILD_NUMBER}')
    script {
        try {
            def COMMIT_AUTHOR_EMAIL = sh(returnStdout: true, script: "git --no-pager show -s --format='%ae'").trim()
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
        } catch (Exception e) {
            echo "Exception occurred: " + e.toString()
            EMAIL_TO = "\$DEFAULT_RECIPIENTS"
        }
        emailext(
            to: "$EMAIL_TO",
            replyTo: "$EMAIL_TO",
            subject: '$DEFAULT_SUBJECT',
            body: '''
$DEFAULT_CONTENT
${FILE, path="flow/reports/report-summary.log"}
            '''
        )
    }
}
