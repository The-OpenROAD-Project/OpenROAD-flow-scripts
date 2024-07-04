@Library('utils@orfs-v2.0.1') _

node('ubuntu22') {

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
        runTests(DOCKER_IMAGE, 'pr');
    }

    stage ('Cleanup and Reporting') {
        finalReport(DOCKER_IMAGE);
    }

}
