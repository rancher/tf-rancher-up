# Kubernetes API audit logging for the downstream cluster. This is what records commands run in
# Rancher's kubectl shell: the shell pod talks to this API server directly, impersonating the
# Rancher user, so they never reach Rancher's own audit log.
locals {
  kube_audit_enabled  = var.kube_audit_policy != null || var.kube_audit_level != "None"
  kube_audit_log_path = "/var/lib/rancher/rke2/server/logs/audit.log"

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

  control_plane_selector = { "rke.cattle.io/control-plane-role" = "true" }
}
