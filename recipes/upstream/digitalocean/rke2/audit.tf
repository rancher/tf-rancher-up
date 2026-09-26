# Kubernetes API audit logging for the Rancher (local) cluster. It records access that bypasses
# Rancher's own audit log, such as the RKE2 admin kubeconfig. The policy must exist before RKE2
# first starts, so it is written by a snippet prepended to the droplets' user_data.
locals {
  kube_audit_enabled     = var.kube_audit_policy != null || var.kube_audit_level != "None"
  kube_audit_policy_path = "/etc/rancher/rke2/audit-policy.yaml"
  kube_audit_log_path    = "/var/lib/rancher/rke2/server/logs/audit.log"

  kube_audit_policy = var.kube_audit_policy != null ? var.kube_audit_policy : yamlencode({
    apiVersion = "audit.k8s.io/v1"
    kind       = "Policy"
    omitStages = ["RequestReceived"]
    rules = [
      # Probes and constant control-plane churn
      { level = "None", nonResourceURLs = ["/healthz*", "/livez*", "/readyz*", "/version"] },
      { level = "None", resources = [{ group = "coordination.k8s.io", resources = ["leases"] }] },
      { level = "None", resources = [{ group = "", resources = ["events"] }, { group = "events.k8s.io", resources = ["events"] }] },
      # Never write secret or token payloads to the log
      {
        level = "Metadata"
        resources = [
          { group = "", resources = ["secrets", "configmaps", "serviceaccounts/token"] },
          { group = "authentication.k8s.io", resources = ["tokenreviews"] },
        ]
      },
      { level = var.kube_audit_level },
    ]
  })

  # Drop-in config, so it cannot clash with keys set through var.rke2_config
  kube_audit_rke2_config = yamlencode({
    "audit-policy-file" = local.kube_audit_policy_path
    "kube-apiserver-arg+" = [
      "audit-log-path=${local.kube_audit_log_path}",
      "audit-log-maxage=${var.kube_audit_log_max_age}",
      "audit-log-maxbackup=${var.kube_audit_log_max_backup}",
      "audit-log-maxsize=${var.kube_audit_log_max_size}",
    ]
  })

  kube_audit_user_data = local.kube_audit_enabled ? join("\n", [
    "mkdir -p /etc/rancher/rke2/config.yaml.d",
    "cat > ${local.kube_audit_policy_path} <<'AUDIT_POLICY'",
    trimspace(local.kube_audit_policy),
    "AUDIT_POLICY",
    "chmod 0600 ${local.kube_audit_policy_path}",
    "cat > /etc/rancher/rke2/config.yaml.d/50-audit.yaml <<'AUDIT_CONFIG'",
    trimspace(local.kube_audit_rke2_config),
    "AUDIT_CONFIG",
    "",
  ]) : ""
}
