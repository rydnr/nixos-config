{ config, pkgs, ... }:

{
  services.kube-apiserver = {
    enable = true;
    advertise-address = "adv-address";
    cloud-provider-gce-l7lb-src-cidrs = [
      "1.1.1.1/1"
      "2.2.2.2/2"
    ];
    cors-allowed-origins = [
      "3.3.3.3/3"
      "4.4.4.4/4"
      "5.5.5.5/5"
    ];
    default-not-ready-toleration-seconds = 1;
    default-unreachable-toleration-seconds = 2;
    enable-priority-and-fairness = true;
    external-hostname = "[external-hostname]";
    feature-gates = [ "feature1" "feature2" ];
    goaway-chance = 1.0;
    livez-grace-period = 3;
    max-mutating-requests-inflight = 4;
    max-requests-inflight = 5;
    min-request-timeout = 6;
    request-timeout = 7;
    shutdown-delay-duration = 8;
    shutdown-send-retry-after = true;
    shutdown-watch-termination-grace-period = 9;
    strict-transport-security-directives = [ "directive1" "directive2" "directive3" ];
    delete-collection-workers = 10;
    enable-garbage-collector = true;
    encryption-provider-config = "[encryption-provider-config]";
    encryption-provider-config-automatic-reload = true;
    etcd-cafile = ./kube-apiserver.nix;
    etcd-certfile = ./kube-apiserver.nix;
    etcd-compaction-interval = "[etcd-compaction-interval]";
    etcd-count-metric-poll-period = "[etcd-count-metric-poll-period]";
    etcd-db-metric-poll-interval = "[etcd-db-metric-poll-interval]";
    etcd-healthcheck-timeout = "[etcd-healthcheck-timeout]";
    etcd-keyfile = ./kube-apiserver.nix;
    etcd-prefix = "[etcd-prefix]";
    etcd-readycheck-timeout = "[etcd-readycheck-timeout]";
    etcd-servers = [ "server1" "server2" ];
    etcd-servers-overrides = [ "server3" "server4" ];
    lease-reuse-duration-seconds = 11;
    storage-backend = "[storage-backend]";
    storage-media-type = "application/json";
    watch-cache = true; # !!
    watch-cache-sizes = [ "size1" "size2" ];
    bind-address = "[bind-address]";
    cert-dir = ./.;
    http2-max-streams-per-connection = 12;
    permit-address-sharing = true; # !!
    permit-port-sharing = true; # !!
    secure-port = 13;
    tls-cert-file = ./kube-apiserver.nix;
    tls-cipher-suites = [ "suite1" "suite2" "suite3" ];
    tls-min-version = "VersionTLS12";
    tls-private-key-file = ./kube-apiserver.nix;
    tls-sni-cert-key = [ "example1.crt,example1.key" "example2.crt,example2.key" ]; # !!
    audit-log-batch-buffer-size = 14;
    audit-log-batch-max-size = 15;
    audit-log-batch-max-wait = "[audit-log-batch-max-wait]";
    audit-log-batch-throttle-burst = 16;
    audit-log-batch-throttle-enable = true; # !!
    audit-log-batch-throttle-qps = 0.3;
    audit-log-compress = true;
    audit-log-format = "json";
    audit-log-maxage = 17;
    audit-log-maxbackup = 18;
    audit-log-maxsize = 19;
    audit-log-mode = "batch";
    audit-log-path = ./.;
    audit-log-truncate-enabled = true;
    audit-log-truncate-max-batch-size = 20;
    audit-log-truncate-max-event-size = 21;
    audit-log-version = "[audit-log-version]";
    audit-policy-file = ./kube-apiserver.nix;
    audit-webhook-batch-buffer-size = 22;
    audit-webhook-batch-max-size = 23;
    audit-webhook-batch-max-wait = 24;
    audit-webhook-batch-throttle-burst = 25;
    audit-webhook-batch-throttle-enable = true; # !!
    audit-webhook-batch-throttle-qps = 13.5;
    audit-webhook-config-file = ./kube-apiserver.nix;
    audit-webhook-initial-backoff = "[audit-webhook-initial-backoff]";
    audit-webhook-mode = "blocking";
    audit-webhook-truncate-enabled = true;
    audit-webhook-truncate-max-batch-size = 26;
    audit-webhook-truncate-max-event-size = 27;
    audit-webhook-version = "[audit-webhook-version]";
    contention-profiling = true;
    debug-socket-path = "[debug-socket-path]";
    profiling = true; # !!
    anonymous-auth = true; # !!
    api-audiences = [ "audience1" "audience2" ];
    authentication-config = ./kube-apiserver.nix;
    authentication-token-webhook-cache-ttl = "[authentication-token-webhook-cache-ttl]";
    authentication-token-webhook-config-file = ./kube-apiserver.nix;
    authentication-token-webhook-version = "[authentication-token-webhook-version]";
    client-ca-file = ./kube-apiserver.nix;
    enable-bootstrap-token-auth = true; # !!
    oidc-ca-file = ./kube-apiserver.nix;
    oidc-client-id = "[oidc-client-id]";
    oidc-groups-claim = "[oidc-groups-claim]";
    oidc-groups-prefix = "[oidc-groups-prefix]";
    oidc-issuer-url = "[oidc-issuer-url]";
    oidc-required-claim = [ "key1=value1" "key2=value2" ]; # OK
    oidc-signing-algs = "RS256";
    oidc-username-claim = "[oidc-username-claim]";
    oidc-username-prefix = "[oidc-username-prefix]";
    requestheader-allowed-names = [ "name1" "name2" ];
    requestheader-client-ca-file = ./kube-apiserver.nix;
    requestheader-extra-headers-prefix = [ "extraHeadersPrefix1" "extraHeadersPrefix2" "extraHeadersPrefix3" ];
    requestheader-group-headers = [ "groupHeader1" "groupHeader2" ];
    requestheader-username-headers = [ "usernameHeader1" "usernameHeader2" "usernameHeader3" "usernameHeader4" ];
    service-account-extend-token-expiration = true; # !!
    service-account-issuer = "[service-account-issuer]";
    service-account-jwks-uri = "[service-account-jwks-uri]";
    service-account-key-file = ./kube-apiserver.nix;
    service-account-lookup = true; # !!
    service-account-max-token-expiration = "[service-account-max-token-expiration]";
    token-auth-file = ./kube-apiserver.nix;
    authorization-config = ./kube-apiserver.nix;
    authorization-mode = [ "AlwaysAllow" "AlwaysDeny" "ABAC" "Webhook" "RBAC" "Node" ];
    authorization-policy-file = ./kube-apiserver.nix;
    authorization-webhook-cache-authorized-ttl = "[authorization-webhook-cache-authorized-ttl]";
    authorization-webhook-cache-unauthorized-ttl = "[authorization-webhook-cache-unauthorized-ttl]";
    authorization-webhook-config-file = ./kube-apiserver.nix;
    authorization-webhook-version = "[authorization-webhook-version]";
    runtime-config = [ "api/all=true" "api/ga=true" "api/beta=true" "api/alpha=true" ];
    egress-selector-config-file = ./kube-apiserver.nix;
    admission-control = [
        "AlwaysAdmit"
        "AlwaysDeny"
        "AlwaysPullImages"
        "CertificateApproval"
        "CertificateSigning"
        "CertificateSubjectRestriction"
        "ClusterTrustBundleAttest"
        "DefaultIngressClass"
        "DefaultStorageClass"
        "DefaultTolerationSeconds"
        "DenyServiceExternalIPs"
        "EventRateLimit"
        "ExtendedResourceToleration"
        "ImagePolicyWebhook"
        "LimitPodHardAntiAffinityTopology"
        "LimitRanger"
        "MutatingAdmissionWebhook"
        "NamespaceAutoProvision"
        "NamespaceExists"
        "NamespaceLifecycle"
        "NodeRestriction"
        "OwnerReferencesPermissionEnforcement"
        "PersistentVolumeClaimResize"
        "PersistentVolumeLabel"
        "PodNodeSelector"
        "PodSecurity"
        "PodTolerationRestriction"
        "Priority"
        "ResourceQuota"
        "RuntimeClass"
        "ServiceAccount"
        "StorageObjectInUseProtection"
        "TaintNodesByCondition"
        "ValidatingAdmissionPolicy"
        "ValidatingAdmissionWebhook"
    ];
    admission-control-config-file = ./kube-apiserver.nix;
    disable-admission-plugins = [
        "NamespaceLifecycle"
        "LimitRanger"
        "ServiceAccount"
        "TaintNodesByCondition"
        "PodSecurity"
        "Priority"
        "DefaultTolerationSeconds"
        "DefaultStorageClass"
        "StorageObjectInUseProtection"
        "PersistentVolumeClaimResize"
        "RuntimeClass"
        "CertificateApproval"
        "CertificateSigning"
        "ClusterTrustBundleAttest"
        "CertificateSubjectRestriction"
        "DefaultIngressClass"
        "MutatingAdmissionWebhook"
        "ValidatingAdmissionPolicy"
        "ValidatingAdmissionWebhook"
        "ResourceQuota"
    ];
    enable-admission-plugins = [
        "AlwaysAdmit"
        "AlwaysDeny"
        "AlwaysPullImages"
        "CertificateApproval"
        "CertificateSigning"
        "CertificateSubjectRestriction"
        "ClusterTrustBundleAttest"
        "DefaultIngressClass"
        "DefaultStorageClass"
        "DefaultTolerationSeconds"
        "DenyServiceExternalIPs"
        "EventRateLimit"
        "ExtendedResourceToleration"
        "ImagePolicyWebhook"
        "LimitPodHardAntiAffinityTopology"
        "LimitRanger"
        "MutatingAdmissionWebhook"
        "NamespaceAutoProvision"
        "NamespaceExists"
        "NamespaceLifecycle"
        "NodeRestriction"
        "OwnerReferencesPermissionEnforcement"
        "PersistentVolumeClaimResize"
        "PersistentVolumeLabel"
        "PodNodeSelector"
        "PodSecurity"
        "PodTolerationRestriction"
        "Priority"
        "ResourceQuota"
        "RuntimeClass"
        "ServiceAccount"
        "StorageObjectInUseProtection"
        "TaintNodesByCondition"
        "ValidatingAdmissionPolicy"
        "ValidatingAdmissionWebhook"
    ];
    allow-metric-labels = [
      "metric1,label1='v1,v2,v3'" "metric1,label2='v1,v2,v3'" "metric2,label1='v1,v2,v3'"
    ]; # ?
    allow-metric-labels-manifest = ./kube-apiserver.nix;
    disabled-metrics = [ "metric1" "metric2" ];
    show-hidden-metrics-for-version = "[show-hidden-metrics-for-version]";
    log-flush-frequency = "[log-flush-frequency]";
    log-json-info-buffer-size = "[log-json-info-buffer-size]";
    log-json-split-stream = true;
    log-text-info-buffer-size = "[log-text-info-buffer-size]";
    log-text-split-stream = true;
    logging-format = "text";
    v = 28;
    vmodule = [ "pattern1=1" "pattern2=2" ];
    tracing-config-file = ./kube-apiserver.nix;
    aggregator-reject-forwarding-redirect = true;
    allow-privileged = true; # !!
    enable-aggregator-routing = true;
    endpoint-reconciler-type = "master-count";
    event-ttl = "[event-ttl]";
    kubelet-certificate-authority = ./kube-apiserver.nix;
    kubelet-client-certificate = ./kube-apiserver.nix;
    kubelet-client-key = ./kube-apiserver.nix;
    kubelet-preferred-address-types = [
      "Hostname" "InternalDNS" "InternalIP" "ExternalDNS" "ExternalIP"
    ];
    kubelet-timeout = "[kubelet-timeout]";
    kubernetes-service-node-port = 29;
    max-connection-bytes-per-sec = 30;
    peer-advertise-ip = "[peer-advertise-ip]";
    peer-advertise-port = 31;
    peer-ca-file = ./kube-apiserver.nix;
    proxy-client-cert-file = ./kube-apiserver.nix;
    proxy-client-key-file = ./kube-apiserver.nix;
    service-account-signing-key-file = ./kube-apiserver.nix;
    service-cluster-ip-range = "[service-cluster-ip-range]";
    service-node-port-range = "[service-node-port-range]";
  };
}
