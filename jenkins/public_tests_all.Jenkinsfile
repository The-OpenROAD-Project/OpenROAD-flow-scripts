@Library('utils@orfs-v2.3.5') _

node {
    
    def isDefaultBranch = (env.BRANCH_NAME == 'master') 
    def daysToKeep = '20';
    def numToKeep = (isDefaultBranch ? '-1' : '10');

    properties([
        copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME),

        buildDiscarder(logRotator(
            daysToKeepStr:         daysToKeep,
            artifactDaysToKeepStr: daysToKeep, 

            numToKeepStr:          numToKeep,
            artifactNumToKeepStr:  numToKeep 
        ))
    ]);

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
