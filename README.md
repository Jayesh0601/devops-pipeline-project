# DevOps Pipeline Project

Complete end-to-end DevOps pipeline built on AWS EC2.

## Architecture

GitHub → Jenkins → SonarQube → Trivy → Docker → DockerHub → ArgoCD → Kubernetes → Prometheus → Grafana

## Tools Used

| Tool | Purpose |
|------|---------|
| Jenkins | CI/CD Pipeline automation |
| SonarQube | Code quality analysis |
| Trivy | Docker image security scanning |
| Docker | Containerization |
| DockerHub | Container image registry |
| Kubernetes | Container orchestration |
| ArgoCD | GitOps continuous deployment |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboards |

## Pipeline Stages

1. Pull code from GitHub
2. Run automated tests (pytest)
3. SonarQube code quality scan
4. Build Docker image
5. Trivy security scan
6. Push to DockerHub
7. Update Kubernetes manifest
8. ArgoCD deploys to Kubernetes
9. Prometheus + Grafana monitor

## Project Structure

devops-pipeline-project/
- app.py - Flask application
- test_app.py - Automated tests
- requirements.txt - Dependencies
- Dockerfile - Container setup
- Jenkinsfile - CI/CD pipeline
- k8s/ - Kubernetes manifests
- argocd/ - ArgoCD configuration
- monitoring/ - Prometheus and Grafana

## Author
Jayesh Daud | linkedin.com/in/jayesh-daud06 | Pune, India