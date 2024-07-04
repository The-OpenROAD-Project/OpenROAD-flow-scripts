@Library('utils@orfs-dev') _

node {

    properties([copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME)]);

    stage('Checkout') {
        checkout scm;
    }

    def DOCKER_IMAGE;
    stage('Build and Push Docker Image') {
        DOCKER_IMAGE = dockerPush('ubuntu22.04', 'orfs');
        echo "Docker image is $DOCKER_IMAGE";
    }

    stage('Build ORFS and Stash bins') {
        buildBins(DOCKER_IMAGE);
    }

    stage('Run Tests') {
        if (env.CHANGE_BRANCH && env.CHANGE_BRANCH.contains('ci-dev')) {
            runTests(DOCKER_IMAGE, 'dev');
        } else {
            runTests(DOCKER_IMAGE, 'pr');
        }
    }

    stage ('Cleanup and Reporting') {
        finalReport(DOCKER_IMAGE);
    }

}
