platforms="nangate45"
designs="gcd aes tinyRocket"

echo "\
pipeline {
  agent any

  stages {
    stage('Build') {
      environment {
        OPENROAD_FLOW_NO_GIT_INIT = 1
      }
      steps {
        sh label: 'Build', script: './build_openroad.sh'
      }
    }

    stage('Test') {
      failFast true
      parallel {" \
  > Jenkinsfile
for platform in $platforms; do
  for design in $designs; do
    echo "\
        stage('${platform}_${design}') {
          steps {
            catchError {
              sh label: '${platform}_${design}', script: '''
              docker run --rm -u \$(id -u \${USER}):\$(id -g \${USER}) openroad/flow bash -c \"source setup_env.sh && cd flow && test/test_helper.sh ${design} ${platform}\"'''
            }
            echo currentBuild.result
          }
        }" \
      >> Jenkinsfile
  done
done
echo "\
      }
    }
  }
}" \
 >> Jenkinsfile
