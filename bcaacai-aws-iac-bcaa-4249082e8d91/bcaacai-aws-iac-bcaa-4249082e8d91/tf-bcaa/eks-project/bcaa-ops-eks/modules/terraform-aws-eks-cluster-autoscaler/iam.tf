resource "kubernetes_namespace" "cluster_autoscaler" {
  depends_on = [var.mod_dependency]
  count      = (var.enabled && var.k8s_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.k8s_namespace
  }
}

### iam ###
# Policy
data "aws_iam_policy_document" "cluster_autoscaler" {
  count = var.enabled ? 1 : 0

  statement {
    sid = "Autoscaling"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeInstanceTypes"
    ]

    resources = [
      "*",
    ]

    effect = "Allow"
  }

}

resource "aws_iam_policy" "cluster_autoscaler" {
  depends_on  = [var.mod_dependency]
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-cluster-autoscaler-role-policy"
  path        = "/"
  description = "Policy for eks cluster-autoscaler service"

  policy =  join("", data.aws_iam_policy_document.cluster_autoscaler.*.json)
}

# Role
data "aws_iam_policy_document" "cluster_autoscaler_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  depends_on         = [var.mod_dependency]
  count              = var.enabled ? 1 : 0
  name               = "${var.cluster_name}-cluster-autoscaler-role"
  assume_role_policy = join("", data.aws_iam_policy_document.cluster_autoscaler_assume.*.json)
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  depends_on = [var.mod_dependency]
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.cluster_autoscaler.*.name)
  policy_arn = join("", aws_iam_policy.cluster_autoscaler.*.arn)
}