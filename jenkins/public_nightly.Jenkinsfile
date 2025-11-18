@Library('utils@orfs-v2.3.6') _

node {

    properties([copyArtifactPermission('${JOB_NAME},'+env.BRANCH_NAME)]);

    stage('Checkout ORFS') {
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
        def description = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim();
        if (description.contains('ci') && description.contains('skip')) {
            currentBuild.result = 'SKIPPED'; // 'SUCCESS', 'SKIPPED'
            return;
        }
    }


    stage('Checkout OpenROAD Latest') {
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
            ]);
    }

    def DOCKER_IMAGE;
    stage('Build and Push Docker Image') {
        DOCKER_IMAGE = dockerPush('ubuntu22.04', 'orfs');
        echo "Docker image is $DOCKER_IMAGE";
    }

    stage('Build ORFS and Stash bins') {
        buildBins(DOCKER_IMAGE, '--local --no_init --latest');
    }

    try {
        stage('Run Tests') {
            if (env.CHANGE_BRANCH && env.CHANGE_BRANCH.contains('ci-dev')) {
                runTests(DOCKER_IMAGE, 'dev');
            } else {
                runTests(DOCKER_IMAGE, 'nightly');
            }
        }
    } catch (e) {
        throw e
    } finally {
        stage ('Cleanup and Reporting') {
            env.CHANGE_BRANCH = 'nightly'
            env.BRANCH_NAME = 'nightly'
            finalReport(DOCKER_IMAGE);
        }
    }

}
