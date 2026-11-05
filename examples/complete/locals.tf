locals {

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  kms_policy_admin_arns = concat([data.aws_iam_session_context.current.arn], var.kms_policy_admin_arns)

}
