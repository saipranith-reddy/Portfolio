pipeline {
    agent any

    environment {
        EC2_HOST = 'ubuntu@15.206.67.8'
        TARGET_DIR = '/var/www/html/'
        SSH_CREDENTIALS_ID = 'portfolio-ssh'
        IMAGE_NAME = 'portfolio'
        CONTAINER_NAME = 'portfolio-container'
        HOST_PORT = '9000'
        CONTAINER_PORT = '80'
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                git url: 'https://github.com/saipranith-reddy/Portfolio.git', branch: 'main'
            }
        }

        stage('List Workspace Files') {
            steps {
                sh 'ls -la'
            }
        }
        //Below code is to deploy to Portfolio EC2
        /*stage('Deploy to EC2') {
            steps {
                sshagent(credentials: [SSH_CREDENTIALS_ID]) {
                    sh '''
                        set -e

                        echo "[INFO] Establishing EC2 connectivity..."
                        ssh -o StrictHostKeyChecking=no $EC2_HOST "echo EC2 connection successful"

                        echo "[INFO] Cleaning existing files on remote EC2..."
                        ssh -o StrictHostKeyChecking=no $EC2_HOST "sudo rm -rf $TARGET_DIR/* || echo 'Cleanup failed'"

                        echo "[INFO] Copying files to EC2..."
                        scp -o StrictHostKeyChecking=no -r * $EC2_HOST:$TARGET_DIR || echo 'SCP failed'

                        echo "[INFO] Restarting Nginx on remote EC2..."
                        ssh -o StrictHostKeyChecking=no $EC2_HOST "sudo systemctl restart nginx || echo 'Nginx restart failed'"

                        echo "[SUCCESS] Files Deployed successfully!"
                    '''
                }
            }
        }*/
        
        //To launch container and host website in Jenkins server.
        stage('Build Docker Image') {
            steps {
                sh '''
                pwd
                ls -la
                docker build -t $IMAGE_NAME .
                '''
            }
        }
        stage('Run Docker Container') {
            steps {
                sh '''
                # Stop and remove existing container if exists
                docker rm -f $CONTAINER_NAME || true

                # Run container with port mapping
                docker run -d -p $HOST_PORT:$CONTAINER_PORT --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }

    }

    post {
        success {
            echo "✅ Deployment succeeded"
        }
        failure {
            echo "❌ Deployment failed — check logs above for details"
        }
    }
}
