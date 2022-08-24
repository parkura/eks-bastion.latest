resource "random_password" "main" {
  length           = 20
  special          = true 
  override_special = "#!()_"
}

resource "aws_ssm_parameter" "jenkins_password" {
  name        = "jenkins_password"
  description = "Admin Password for Jenkins"
  type        = "SecureString"
  value       = random_password.main.result
}

data "aws_ssm_parameter" "jenkins_password" {
  name       = "jenkins_password"
  depends_on = [aws_ssm_parameter.jenkins_password]
}

output "jenkins_password" {
  value     = data.aws_ssm_parameter.jenkins_password.value
  sensitive = true
}