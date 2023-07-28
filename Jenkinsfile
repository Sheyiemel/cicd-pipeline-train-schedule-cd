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
        stage('DeployTovmone') {
            when {
                branch 'deployapp'
            }
            steps {
               script {
                   sshagent(['vmone-cred']) {
                      sh 'ssh -o StrictHostKeyChecking=no ec2-user@44.203.43.242'
                      transfers: [
                          sshTransfer(
                              sourceFiles: 'dist/trainSchedule.zip',
                              removePrefix: 'dist/',
                              remoteDirectory: '/tmp',
                              execCommand: 'sudo /usr/bin/systemctl stop train-schedule && rm -rf /opt/train-schedule/* && unzip /tmp/trainSchedule.zip -d /opt/train-schedule && sudo /usr/bin/systemctl start train-schedule'
                          )
                      ]
                   }
               }
            }
        }
    }
}
