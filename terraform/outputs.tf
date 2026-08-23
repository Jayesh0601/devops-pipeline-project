output "jenkins_public_ip" {
  description = "SSH here, or open :8080 for Jenkins / :9000 for SonarQube"
  value       = module.jenkins.public_ip
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Run this command after apply to point kubectl at your new EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
