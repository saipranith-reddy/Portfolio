pipeline {
    agent any

    environment {
        EC2_HOST = 'ubuntu@15.206.67.8'
        TARGET_DIR = '/var/www/html/'
        SSH_CREDENTIALS_ID = 'portfolio-ssh'
    }

    stages {
        
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

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: [SSH_CREDENTIALS_ID]) {
                    sh '''
                    set -e  # Stop immediately if a command exits with a non-zero status

                    echo "[DEBUG] Verifying EC2 connectivity..."
                    ssh -vvv -o StrictHostKeyChecking=no $EC2_HOST "echo EC2 connection successful"

                    echo "[INFO] Cleaning existing files on remote EC2..."
                    ssh -o StrictHostKeyChecking=no $EC2_HOST "rm -rf $TARGET_DIR/* || echo 'Cleanup failed'"

                    echo "[INFO] Copying files to EC2..."
                    scp -o StrictHostKeyChecking=no -r * $EC2_HOST:$TARGET_DIR || echo 'SCP failed'

                    echo "[INFO] Restarting Nginx on remote EC2..."
                    ssh -o StrictHostKeyChecking=no $EC2_HOST "sudo systemctl restart nginx || echo 'Nginx restart failed'"

                    echo "[SUCCESS] Deployment completed successfully!"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded"
        }
        failure {
            echo "❌ Deployment failed – check logs above for details"
        }
    }
}
