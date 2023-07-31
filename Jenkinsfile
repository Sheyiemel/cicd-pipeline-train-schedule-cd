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
        stages {
       stage('Build Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh 'docker build -t seyiemel/seyimages:train-schedule .'
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push seyiemel/seyimages:train-schedule'
                }
            }
        }
        stage ('Deploy') {
            steps {
                script {
                    echo 'deploying application'
                    def dockerCmd = 'docker run  -p 8080:8080 -d seyiemel/seyimages:train-schedule:latest'
                    sshagent(['tf-key-pair']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.92.144.96 ${dockerCmd}"
                    }
                }
            }
        }
    }
}
