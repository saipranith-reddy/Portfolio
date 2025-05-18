pipeline {
    agent any

    stages {
        stage('Create Docker image') {
            steps {
                sh 'docker build -t testingpipeline:v1 .'
            }
        }
        stage('Deleting old container') {
            steps {
                sh 'docker rm -f httpd'
            }
        }
        
        
        stage('Create a container') {
            steps {
                sh 'docker run -d --name httpd -p 82:80 testingpipeline:v1'
            }
        }
        stage('Dangling Image remove') {
            steps {
                sh 'docker rmi -f $(docker images -f dangling=true)'
            }
        }
        
    }
}
