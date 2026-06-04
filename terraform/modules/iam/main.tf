locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_iam_policy_document" "kops_operator" {
  statement {
    sid    = "KopsStateBucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]

    resources = [var.kops_state_bucket_arn]
  }

  statement {
    sid    = "KopsStateObjectAccess"
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]

    resources = ["${var.kops_state_bucket_arn}/*"]
  }

  statement {
    sid    = "KopsClusterInfrastructure"
    effect = "Allow"

    actions = [
      "autoscaling:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "iam:*",
      "route53:*",
      "sqs:*",
      "events:*",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "kms:DescribeKey",
      "kms:ListAliases"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "kops_operator" {
  name        = "${local.name_prefix}-kops-operator"
  description = "Permissions for Kops cluster creation and day-two operations for the capstone project."
  policy      = data.aws_iam_policy_document.kops_operator.json

  tags = var.tags
}

data "aws_iam_policy_document" "kops_operator_assume_role" {
  count = length(var.kops_operator_principal_arns) > 0 ? 1 : 0

  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.kops_operator_principal_arns
    }
  }
}

resource "aws_iam_role" "kops_operator" {
  count = length(var.kops_operator_principal_arns) > 0 ? 1 : 0

  name               = "${local.name_prefix}-kops-operator"
  assume_role_policy = data.aws_iam_policy_document.kops_operator_assume_role[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "kops_operator" {
  count = length(var.kops_operator_principal_arns) > 0 ? 1 : 0

  role       = aws_iam_role.kops_operator[0].name
  policy_arn = aws_iam_policy.kops_operator.arn
}
