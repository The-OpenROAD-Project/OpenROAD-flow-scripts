@Library('utils@orfs-arm') _

node {

    properties([copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME)]);

    stage('Checkout') {
        if (env.BRANCH_NAME && env.BRANCH_NAME == 'master') {
            checkout([
                    $class: 'GitSCM',
                    branches: [[name: scm.branches[0].name]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                    [$class: 'CloneOption', noTags: false],
                    [$class: 'SubmoduleOption', recursiveSubmodules: true]
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: scm.userRemoteConfigs
            ]);
        }
        else {
            checkout scm;
        }
        def description = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim();
        if (description.contains('ci') && description.contains('skip')) {
            currentBuild.result = 'SKIPPED'; // 'SUCCESS', 'SKIPPED'
            return;
        }
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
        runTests(DOCKER_IMAGE, 'dev');
    }

    stage ('Cleanup and Reporting') {
        finalReport(DOCKER_IMAGE);
    }

}
