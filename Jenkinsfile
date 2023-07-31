pipeline {
    agent any
    environment {
        SSH_PRIVATE_KEY = credentials('tf-key-pair')
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('DeployTovmone') {
           steps {
                        // Define the SSH credentials to connect to the deployment server
               withCredentials([sshagent(credentials: ['tf-key-pair'])]) {
                            // Transfer files from Jenkins workspace to the deployment server
                   script {
                                // Replace 'your-local-file.zip' with the path to the zip file in your Jenkins workspace
                       sh 'scp -r dist/trainSchedule.zip ec2-user@3.92.19.13:/tmp/'
                   }
               }

                        // Unzip the file on the deployment server
               script {
                   sshCommand remote: 'ec2-user@3.92.19.13', command: 'unzip /tmp/trainSchedule.zip -d /opt/train-schedule'
               }

                        // Start the application on the deployment server
               script {
                        sshCommand remote: 'ec2-user@3.92.19.13', command: 'cd /opt/train-schedule && ./start train-schedule'
               }
           }        
        }
    }
}
