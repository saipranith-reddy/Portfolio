pipeline {
    agent any

    environment {
        EC2_HOST = 'ubuntu@15.206.67.8'              // ✅ portfolio EC2 user@IP
        TARGET_DIR = '/var/www/html/'       // ✅ Nginx root directory
        SSH_CREDENTIALS_ID = 'portfolio-ssh'               // ✅ Jenkins Credentials ID for portfolio EC2 SSH key
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                git 'https://github.com/saipranith-reddy/Portfolio.git'  // ✅ Potfolio github repo
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
                    echo "[INFO] Cleaning existing files on remote EC2..."
                    ssh -o StrictHostKeyChecking=no $EC2_HOST "rm -rf $TARGET_DIR/*"

                    echo "[INFO] Copying files to EC2..."
                    scp -o StrictHostKeyChecking=no -r * $EC2_HOST:$TARGET_DIR

                    echo "[INFO] Restarting Nginx on remote EC2..."
                    ssh -o StrictHostKeyChecking=no $EC2_HOST "sudo systemctl restart nginx"

                    echo "[INFO] Deployment completed to $EC2_HOST:$TARGET_DIR and Nginx restarted"
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
            echo "❌ Deployment failed"
        }
    }
}
