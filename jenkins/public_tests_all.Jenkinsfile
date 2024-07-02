@Library('utils@main') _

node {

    properties([
            copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME),
    ]);

    stage('Checkout') {
        checkout scm;
    }

    def commitHash = "none";
    def DOCKER_IMAGE_TAG = "latest";
    stage('Build and Push Docker Image') {
        if (isDependencyInstallerChanged(env.BRANCH_NAME)) {
            commitHash = sh(script: 'git rev-parse HEAD', returnStdout: true);
            commitHash = commitHash.replaceAll(/[^a-zA-Z0-9-]/, '');
            DOCKER_IMAGE_TAG = pushCIImage(env.BRANCH_NAME, commitHash);
        }
    }
    def DOCKER_IMAGE = "openroad/flow-ubuntu22.04-dev:${DOCKER_IMAGE_TAG}";

    docker.image("${DOCKER_IMAGE}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
        stage('Build ORFS and Stash bins') {
            sh "git config --system --add safe.directory '*'";
            localBuild();
        }
    }

    stage('Run Tests') {
        Map tasks = [failFast: false];
        def test_slugs = getTestSlugs("all");
        for (test in test_slugs) {
            def currentSlug = test; // copy needed to correctly pass args to runTests
            tasks["${test}"] = {
                node {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        docker.image("${DOCKER_IMAGE}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
                            sh "git config --system --add safe.directory '*'";
                            checkout scm;
                            runTests(currentSlug);
                        }
                    }
                }
            }
        }
        parallel(tasks);
    }

    docker.image("${DOCKER_IMAGE}").inside('--user=root --privileged -v /var/run/docker.sock:/var/run/docker.sock') {
        sh "git config --system --add safe.directory '*'";
        stage('Report Summary') {
            generateReportShortSummary();
        }
        stage("Report HTML Table") {
            generateReportHtmlTable();
        }
        stage('Upload Metadata') {
            uploadMetadata(env.BRANCH_NAME, commitHash);
        }
        stage('Send Report') {
            def COMMIT_AUTHOR_EMAIL = sh(script: "git --no-pager show -s --format='%ae'", returnStdout: true).trim();
            sendEmail(env.BRANCH_NAME, COMMIT_AUTHOR_EMAIL);
        }
    }

}
