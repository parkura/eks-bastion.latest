provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config"
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  values = [
    "${file("jenkins-values.yaml")}"
  ]

  set_sensitive {
    name  = "controller.adminUser"
    value = " "
  }
  set_sensitive {
    name  = "controller.adminPassword"
    value = data.aws_ssm_parameter.jenkins_password.value
  }
  set_sensitive {
    name  = "adminPassword"
    value =  data.aws_ssm_parameter.jenkins_password.value
  }
}

resource "helm_release" "ingress" {
  name       = "ingress"
  chart      = "aws-alb-ingress-controller"
  repository = "https://charts.helm.sh/incubator"
  version    = "1.0.2"
  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = local.cluster_name
  }
}
