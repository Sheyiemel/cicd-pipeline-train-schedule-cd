pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
       stage('Build Image') {
           steps {
               withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                   sh 'docker build -t seyiemel/seyimages:train-schedule-1.0 .'
                   sh "echo $PASS | docker login -u $USER --password-stdin"
                   sh 'docker push seyiemel/seyimages:train-schedule-1.0'
               }
           }
       }
       stage ('Deploy') {
           steps {
               withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                   script {
                       echo 'deploying application'
                       sshagent(['tf-key-pair']) {
                           sh 'ssh -o StrictHostKeyChecking=no ec2-user@34.204.75.103'
                           sh "echo $PASS | docker login -u $USER --password-stdin"
                           sh 'docker run  -p 8081:8081 -d seyiemel/seyimages:train-schedule-1.0'
                       }
                   }
               }
           }
       }
    }
}
