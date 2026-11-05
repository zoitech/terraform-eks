resource "aws_kms_key" "k8s_secret_key" {
  count = var.enable_cluster_encryption_config ? 1 : 0

  description = "KMS key for encrypting Kubernetes secrets"
}

resource "aws_kms_alias" "k8s_secret_key_alias" {
  count = var.enable_cluster_encryption_config ? 1 : 0

  name          = "alias/k8s_secrets_${var.cluster-name}"
  target_key_id = aws_kms_key.k8s_secret_key[0].id
}

resource "aws_kms_key_policy" "k8s_secret_key" {
  count = var.enable_cluster_encryption_config ? 1 : 0

  key_id = aws_kms_key.k8s_secret_key[0].id
  policy = data.aws_iam_policy_document.kms_policy[0].json
}

data "aws_iam_policy_document" "kms_policy" {
  count = var.enable_cluster_encryption_config ? 1 : 0

  dynamic "statement" {
    for_each = length(var.secrets_manager_iam_role_arns) > 0 ? [var.secrets_manager_iam_role_arns] : []
    content {
      sid     = "EKS access"
      actions = ["kms:Decrypt"]
      effect  = "Allow"
      principals {
        type        = "AWS"
        identifiers = statement.value
      }
      resources = ["*"]
    }
  }


  statement {
    sid     = "Allow administration of the key"
    actions = ["kms:*"]
    effect  = "Allow"
    principals {
      type = "AWS"
      identifiers = concat(var.kms_policy_admin_arns, [
        data.aws_caller_identity.current.arn,
      ])
    }
    resources = ["*"]
  }

  statement {
    sid    = "EKS Master Role uses key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.enable_iam ? aws_iam_role.eks-masters[0].arn : var.eks-masters-iam-role]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EKS Master Role may attach persistent resources"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.enable_iam ? aws_iam_role.eks-masters[0].arn : var.eks-masters-iam-role]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }

  }
}
