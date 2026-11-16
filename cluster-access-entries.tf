resource "aws_eks_access_entry" "cluster-access-entries" {
  for_each = var.eks_ns_access_entries

  cluster_name      = aws_eks_cluster.cluster-masters.name
  principal_arn     = each.value.principal_arn
  type              = var.eks_access_entry_type
  kubernetes_groups = each.value.kubernetes_groups
}

resource "aws_eks_access_policy_association" "cluster_access_policy" {
  for_each = merge([
    for entry_key, entry_value in var.eks_ns_access_entries :
    {
      for policy_arn in entry_value.policy_arns :
      "${entry_key}/${policy_arn}" => {
        principal_arn     = entry_value.principal_arn
        policy_arn        = policy_arn
        access_scope_type = entry_value.access_scope_type
        namespaces        = entry_value.namespaces
      }
    }
  ]...) # ... splat operator

  cluster_name  = aws_eks_cluster.cluster-masters.name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type       = each.value.access_scope_type
    namespaces = each.value.namespaces
  }

  depends_on = [aws_eks_access_entry.cluster-access-entries]
}
