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
                   sh 'docker rmi seyiemel/seyimages:train-schedule-1.0'
               }
           }
       }
       stage ('Deploy') {
           steps {
               withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                   script {
                       echo 'deploying application'
                       sshagent(['tf-key-pair']) {
                           sh "ssh -o StrictHostKeyChecking=no ec2-user@54.161.4.58 \"echo $PASS | docker login -u $USER --password-stdin\""
                           sh "ssh -o StrictHostKeyChecking=no ec2-user@54.161.4.58 \"docker run --restart always --name train-schedule -p 8080:8080 -d seyiemel/seyimages:train-schedule-1.0\""
                       }
                   }
               }
           }
       }
    }
}
