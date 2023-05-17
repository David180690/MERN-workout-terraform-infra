data "tls_certificate" "eks" {
  url = aws_eks_cluster.demo_mern.identity[0].oidc[0].issuer
  #url = "https://oidc.eks.eu-central-1.amazonaws.com/id/18F5E4676F6C8C50DCB1935BFDF7569E"

}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo_mern.identity[0].oidc[0].issuer
  #url = "https://oidc.eks.eu-central-1.amazonaws.com/id/18F5E4676F6C8C50DCB1935BFDF7569E"
}