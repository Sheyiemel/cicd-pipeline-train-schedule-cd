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
            stage('DeployTovmone') {
                steps {
                        // Define the SSH credentials to connect to the deployment server
                     sshagent(['vmone-cred']) {
                            // Transfer files from Jenkins workspace to the deployment server
                         script {
                                // Replace 'your-local-file.zip' with the path to the zip file in your Jenkins workspace
                             sh 'scp -r dist/trainSchedule.zip ec2-user@44.203.43.242:/tmp/'
                         }
                     }

                        // Unzip the file on the deployment server
                     script {
                         sshCommand remote: 'ec2-user@44.203.43.242', command: 'unzip /tmp/trainSchedule.zip -d /opt/train-schedule'
                     }

                        // Start the application on the deployment server
                     script {
                         sshCommand remote: 'ec2-user@44.203.43.242', command: 'cd /opt/train-schedule && ./start train-schedule'
                     }
                }
            }
        }
    }
}
