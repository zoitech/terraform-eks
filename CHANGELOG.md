# Changelog

## [3.0.0]

BREAKING CHANGES:

* Terraform version 1.4.x or newer is required (`terraform_data`, `optional()` object attributes, `replace_triggered_by`).
* Provider requirements: `hashicorp/aws >= 5.0`, `hashicorp/kubernetes >= 3.0`, and `hashicorp/tls >= 4.0`.
* **Renamed/removed variables:**
  * `eks-version` -> `master-nodes-k8s-version`
  * `nodes-version` -> `worker-nodes-k8s-version`
  * `primary-instance-type` (string) -> `nodegroup-instance-types` (list of strings)
  * `region` removed (unused in module; AWS region should be configured at the provider level)
* **Renamed/removed outputs:**
  * `oidc_provider_issuer` -> `cluster_oidc_provider_issuer`
  * `eks_endpoint` -> `cluster_endpoint`
  * `eks_ca` -> `cluster_certificate_authority_data`
  * `eks_nodes_launch_template_id` removed
* **Node group naming changed** - Primary node group now uses `node_group_name_prefix` (`{substr(cluster-name, 0, 28)}-nodes-`) and spot node group includes the launch template ID (`{cluster-name}-spot-ng-{lt-id}`) to enable graceful rolling upgrades. Existing primary and spot node groups will be replaced.
* **kube-proxy and VPC-CNI add-ons are no longer created by `create_eks_addons` alone** - each add-on now needs its own flag (`enable_kube_proxy_addon`, `enable_vpc_cni_addon`, `enable_coredns_addon`, `enable_ebs_csi_addon`), all defaulting to `false`. Set them to `true` on existing clusters, otherwise Terraform will delete the add-ons.
* **Resource addresses changed** - add a `moved` block or run `terraform state mv` to avoid re-creation:
  * `kubernetes_config_map.aws_auth` -> `kubernetes_config_map_v1.aws_auth`
* Add-on `resolve_conflicts` (default `NONE`) replaced by `resolve_conflicts_on_create = "OVERWRITE"` and configurable `resolve_conflicts_on_update` (default `OVERWRITE`).
* **Nodes now use the EKS-optimized Amazon Linux 2023 AMI ID** (retrieved from the public `aws_ssm_parameter`) in the launch template. For existing clusters, the launch template must be re-created (e.g. `terraform taint module.<your-module>.aws_launch_template.cluster-nodes-launch-template`), otherwise the upgrade fails with:
`InvalidParameterException: You cannot specify an image id within the launch template, since your nodegroup is configured to use an EKS optimized AMI.`
* **Custom userdata must include the NodeConfig** - If you pass your own file via `userdata-file`, it overrides the default and you must add the contents of `userdata_node_config` from [userdata.tf](userdata.tf) to it.
* AWS Load Balancer Controller deployment removed - plan accordingly before migrating.
* Cluster AutoScaler deployment removed - plan accordingly before migrating.

ADDED:

* Kubernetes Secrets encryption with a KMS key (`enable_cluster_encryption_config`, `cluster_encryption_config`). Disabled by default to avoid breaking existing clusters.
* `kms_policy_admin_arns` - ARNs added to the KMS key policy as key administrators.
* `secrets_manager_iam_role_arns` - IAM role ARNs allowed to decrypt with the KMS key.
* `cluster-authentication-mode` - Set the cluster authentication mode to support transitioning from ConfigMap to EKS access entries.
* Cluster access entries configuration (`eks_access_entry_type`, `eks_ns_access_entries`), with support for multiple access policy associations per entry and Kubernetes groups (e.g. for CRD permissions).
* `bootstrap_cluster_creator_admin_permissions` - Bootstrap cluster creator admin permissions. Should be set to `true` if the authentication mode is `CONFIG_MAP` in new clusters.
* `userdata.tf` - Default userdata for EKS node groups, including NodeConfig.
* `force_update_version` - Force pod evictions during node group changes.
* `force_ami_update` - Force AMI updates (e.g. security patches) without changing `worker-nodes-k8s-version`.
* `coredns_configuration_values` - Passed to `aws_eks_addon.core_dns` as `configuration_values`, allowing a custom CoreDNS `corefile` (or other addon configuration) through the AWS-managed addon. Defaults to `null`, preserving the addon's built-in defaults.
* EBS CSI driver EKS add-on (`enable_ebs_csi_addon`, `ebs_csi_driver_version`, `eks_addon_resolve_conflicts_ebs_csi`) with a dedicated IRSA role (`EBSCSIDriverRole_{cluster-name}`) that has `AmazonEBSCSIDriverPolicy` attached.
* Individual enable/disable flags for each add-on (`enable_kube_proxy_addon`, `enable_vpc_cni_addon`, `enable_coredns_addon`, `enable_ebs_csi_addon`).
* `eks_addon_resolve_conflicts_kube_proxy`, `eks_addon_resolve_conflicts_core_dns`, `eks_addon_resolve_conflicts_vpc_cni` - Conflict resolution on add-on updates (`NONE`, `OVERWRITE`, `PRESERVE`).
* IAM OIDC provider for IRSA (`enable-oidc-provider`), enabled automatically when the EBS CSI add-on is enabled.
* `eks_svc_account_roles` - IAM roles for Kubernetes service accounts (IRSA), created when the OIDC provider is enabled.
* `enabled_cluster_log_types` - Configurable control plane log types (defaults to all types, as before).
* `aws_auth_labels` - Additional labels for the `aws-auth` ConfigMap.
* Input validation for `eks_addon_resolve_conflicts_kube_proxy` (`NONE`, `OVERWRITE`, `PRESERVE`).
* Outputs: `cluster_name`, `cluster_endpoint`, `cluster_certificate_authority_data`, `eks_nodes_role_name`, `secondary_oidc_provider_url`, `secondary_oidc_provider_arn`.
* Example [examples/minimal-secrets-encryption-enabled](examples/minimal-secrets-encryption-enabled/) demonstrating a minimal EKS cluster with KMS secrets encryption.
* Allow `provider.tf` and `terraform.tfvars` inside `examples/` subdirectories in [.gitignore](.gitignore).

CHANGES:

* **Modernized Terraform HCL syntax** - Replaced legacy index access (e.g. `scaling_config[0].desired_size` instead of deprecated `scaling_config.0.desired_size`) and simplified string interpolations.
* **Broadened AWS provider constraint** - Relaxed `aws` provider version requirement from `~> 6.0` to `>= 5.0`.
* **Add-on versions are resolved dynamically** - When an add-on version is not explicitly set, the default version is retrieved via the `aws_eks_addon_version` data source (queried only when needed).
* **`worker-nodes-k8s-version` is now optional** - If empty (`""`), it defaults to `master-nodes-k8s-version` for both node and add-on version selection. If set, it is used instead, allowing independent version management.
* Launch template uses `name_prefix` with a `create_before_destroy` lifecycle rule. It is replaced (new node group) when `worker-nodes-k8s-version` or `force_ami_update` changes, via `terraform_data.node_version_trigger`. A new recommended AMI published by AWS updates the launch template in place, which triggers a rolling update of the existing node group.
* Node groups use a `create_before_destroy` lifecycle rule for zero-downtime upgrades.
* Node groups support multiple instance types (`nodegroup-instance-types`).
* kube-proxy, CoreDNS, VPC-CNI and EBS CSI add-ons are created after the primary node group; CoreDNS no longer requires the primary node group to be enabled.
* Cluster creation waits for the KMS key policy when secrets encryption is enabled.
* IAM resources moved from `iam.tf` to `iam_resources.tf` (no address changes).
* `provider.tf` removed from the module; see README for provider configuration.

ENHANCEMENTS:

* **Graceful cluster upgrades** - When the AMI or node version changes:
  1. A new node group is created with the new launch template
  2. Pods are gracefully drained from old nodes to new ones
  3. The old node group is destroyed after all pods migrate
  4. Zero workload disruption when using Pod Disruption Budgets (PDB)
* **Flexible version management** - Supports synchronized versioning (`master-nodes-k8s-version` only) or independent versioning (separate `worker-nodes-k8s-version`).

REMOVED:

* `userdata.txt`
* EKS version on the spot instances node group (now determined by the AMI ID).

FIX:

* Removed session name from users.

## [2.1.2]

Make CoreDNS optional

## [2.1.1]

Hotfix: Remove AWS Provider.

## [2.1.0]

ENHANCEMENTS:
* Upgraded terraform version to 0.15
[#11](https://generic/tf-modules/tf-mod-aws-eks/-/issues/11)

BACKWARDS INCOMPATIBILITIES / NOTES:
* Terraform version 0.15.x

## [2.0.2]

FEATURE:
* Change cluster-addon resolve_conflicts to "NONE"

## [2.0.1]

FEATURE:
* Variables for spot instance scaling

## [2.0.0]

ENHANCEMENTS:
* Upgraded terraform version to 0.14
[#9](https://generic/tf-modules/tf-mod-aws-eks/-/issues/9)

## [1.0.7]

FEATURE:
* Update documentation and Changelog

## [1.0.6]

FEATURE:
* Make IAM resources optional

## [1.0.5]

FEATURE:
* Add Terraform Managed AddOns

## [1.0.4]

FEATURE:
* Add support for service IPs

## [1.0.2]

FEATURE:
* Added support for aws-auth configmap management.(Please see README for more important information)

## [1.0.1]

FEATURE:
* Allow passing userdata to the launch template

## [1.0.0]

ENHANCEMENTS:
* Upgraded terraform version to 0.13

## [0.2.2]

ENHANCEMENTS:
* Added support for spot instance node group.

## [0.2.1]

ENHANCEMENTS:
* Added support for tags on nodes using a launch template.

## [0.2.0] - 2021-02-12

ENHANCEMENTS:
* Updated README.md
* Added versions.tf

BACKWARDS INCOMPATIBILITIES / NOTES:
* Terraform version 0.12.x

## [0.1.0] - 2020-09-21

### Added

- Initial version.
