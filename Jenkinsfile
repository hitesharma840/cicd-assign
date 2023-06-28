pipeline {
  agent {
    label 'upgrad'
  }
  parameters {
    string(
      name: 'ips',
      defaultValue: '10.0.1.162',
      description: 'Comma seprated IPs'
      )
  }
  stages {
    stage('Git Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      parallel {
        stage('Build Docker Image') {
          steps {
            sh 'docker build . -t 472601128281.dkr.ecr.us-east-1.amazonaws.com/hitesh-cicd-assignment:${BUILD_NUMBER}'
            sh 'docker push 472601128281.dkr.ecr.us-east-1.amazonaws.com/hitesh-cicd-assignment:${BUILD_NUMBER}'
          }
        }

        stage('Unit Testing') {
          steps {
            sh 'echo Run the Test Cases'
          }
        }

      }
    }

    stage('Deploy in app host') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: "ec2-user", keyFileVariable: 'keyfile')]){
        script {
          sh'''
ssh -o StrictHostKeyChecking=no -t -i ${keyfile} ${ips} "docker stop nodeapp; docker container run -d -p 8081:8081 -v node:/var/ --name nodeapp 472601128281.dkr.ecr.us-east-1.amazonaws.com/hitesh-cicd-assignment:${BUILD_NUMBER}"
       '''
        }

      }
    }
  }
    stage('Adding New Stage') {
      steps {
        sh 'echo adding a new stage'
      }
    }
  }
  post {
    always {
      deleteDir()
      sh 'docker rmi 472601128281.dkr.ecr.us-east-1.amazonaws.com/hitesh-cicd-assignment:${BUILD_NUMBER}'
    }

  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
    timeout(time: 1, unit: 'HOURS')
  }
}
