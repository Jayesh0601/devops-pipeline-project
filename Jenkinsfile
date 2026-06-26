pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "jayeshdaud06/devops-pipeline-project"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout Code') {
            steps {
                echo 'Pulling latest code from GitHub...'
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing Python dependencies...'
                // Added --break-system-packages to bypass the PEP 668 restriction safely in CI/CD
                sh 'pip3 install -r requirements.txt --break-system-packages'
            }
        
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running automated tests...'
                sh 'pytest test_app.py -v'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube code quality scan...'
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=devops-pipeline \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://localhost:9000
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            }
        }
        
        stage('Trivy Security Scan') {
            steps {
                echo 'Scanning Docker image for vulnerabilities...'
                sh "trivy image --severity HIGH,CRITICAL ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                echo 'Pushing image to DockerHub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Update K8s Manifest') {
            steps {
                echo 'Updating Kubernetes deployment manifest...'
                withCredentials([usernamePassword(
                    credentialsId: 'github-credentials',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_PASS'
                )]) {
                    sh """
                        sed -i 's|image:.*|image: ${DOCKER_IMAGE}:${DOCKER_TAG}|g' k8s/deployment.yaml
                        git config user.email "jenkins@devops.com"
                        git config user.name "Jenkins"
                        git add k8s/deployment.yaml
                        git commit -m "Update image tag to ${DOCKER_TAG} [skip ci]"
                        git push https://${GIT_USER}:${GIT_PASS}@github.com/Jayesh0601/devops-pipeline-project.git main
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed! ArgoCD will now deploy automatically.'
        }
        failure {
            echo 'Pipeline failed! Check logs above.'
        }
    }
}