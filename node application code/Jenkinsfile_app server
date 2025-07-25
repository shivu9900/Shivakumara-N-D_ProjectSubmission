pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '237458753027.dkr.ecr.us-east-1.amazonaws.com/node-app'  // ✅ Use actual ECR repo URI
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/shivu9900/node-demo-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t node-app:${IMAGE_TAG} .'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO'
                }
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                script {
                    sh '''
                        docker tag node-app:${IMAGE_TAG} $ECR_REPO:${IMAGE_TAG}
                        docker push $ECR_REPO:${IMAGE_TAG}
                    '''
                }
            }
        }
         stage('Deploy to App Host') {
    steps {
        echo 'Deploying container on app host...'
        sh '''
ssh -o StrictHostKeyChecking=no -i ~/.ssh/upgrad_task_key ubuntu@10.100.3.135 << 'ENDSSH'
  # Stop and remove existing container (if any)
  if docker ps -q --filter name=node-demo-app | grep -q .; then
    echo "Stopping old container..."
    docker stop node-demo-app
    docker rm node-demo-app
  fi

  # Login to ECR
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 237458753027.dkr.ecr.us-east-1.amazonaws.com

  # Pull latest image
  docker pull 237458753027.dkr.ecr.us-east-1.amazonaws.com/node-app:latest

  # Run the new container
  docker run -d --name node-demo-app -p 5000:5000 237458753027.dkr.ecr.us-east-1.amazonaws.com/node-app:latest
ENDSSH
        '''
    }
}

    }
}
