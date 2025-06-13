version: v1alpha1
debug: false
persist: true
machine:
    type: controlplane
    token: {{ "{{ .Secrets.trustdinfo.token }}" }}
    ca:
        crt: {{ "{{ .Secrets.certs.os.crt }}" }}
        key: {{ "{{ .Secrets.certs.os.key }}" }}
    certSANs: []
    kubelet:
        image: ghcr.io/siderolabs/kubelet:{{ .Values.version.k8s }}
        defaultRuntimeSeccompProfileEnabled: true
        disableManifestsDirectory: true
        extraConfig:
          serializeImagePulls: false
    install:
        image: factory.talos.dev/installer/{{ .Values.schematics.controlplane.id }}:{{ .Values.version.talos }}
        wipe: false
{{ tmpl.Exec "registries" .Values.registries | indent 4 }}
    features:
        rbac: true
        stableHostname: true
        apidCheckExtKeyUsage: true
        diskQuotaSupport: true
        kubePrism:
            enabled: true
            port: 7445
        hostDNS:
            enabled: true
            forwardKubeDNSToHost: true
    nodeLabels:
        node.kubernetes.io/exclude-from-external-load-balancers: ""
    files:
        # Spegel
      - op: create
        path: /etc/cri/conf.d/20-customization.part
        content: |
          [plugins."io.containerd.cri.v1.images"]
            discard_unpacked_layers = false
cluster:
    id: {{ "{{ .Secrets.cluster.id }}" }}
    secret: {{ "{{ .Secrets.cluster.secret }}" }}
    controlPlane:
        endpoint: https://k8s.studiop:6443
    clusterName: studiop
    network:
        dnsDomain: cluster.local
        podSubnets:
            - 10.244.0.0/16
        serviceSubnets:
            - 10.96.0.0/12
        
    token: {{ "{{ .Secrets.secrets.bootstraptoken }}" }}
    secretboxEncryptionSecret: {{ "{{ .Secrets.secrets.secretboxencryptionsecret }}" }}
    ca:
        crt: {{ "{{ .Secrets.certs.k8s.crt }}" }}
        key: {{ "{{ .Secrets.certs.k8s.key }}" }}
    aggregatorCA:
        crt: {{ "{{ .Secrets.certs.k8saggregator.crt }}" }}
        key: {{ "{{ .Secrets.certs.k8saggregator.key }}" }}
    serviceAccount:
        key: {{ "{{ .Secrets.certs.k8sserviceaccount.key }}" }}
    apiServer:
        image: registry.k8s.io/kube-apiserver:{{ .Values.version.k8s }}
        certSANs:
            - k8s.studiop
        disablePodSecurityPolicy: true
        admissionControl:
            - name: PodSecurity
              configuration:
                apiVersion: pod-security.admission.config.k8s.io/v1alpha1
                defaults:
                    audit: restricted
                    audit-version: latest
                    enforce: baseline
                    enforce-version: latest
                    warn: restricted
                    warn-version: latest
                exemptions:
                    namespaces:
                        - kube-system
                    runtimeClasses: []
                    usernames: []
                kind: PodSecurityConfiguration
        auditPolicy:
            apiVersion: audit.k8s.io/v1
            kind: Policy
            rules:
                - level: Metadata
    controllerManager:
        image: registry.k8s.io/kube-controller-manager:{{ .Values.version.k8s }}
    proxy:
        image: registry.k8s.io/kube-proxy:{{ .Values.version.k8s }}
        
    scheduler:
        image: registry.k8s.io/kube-scheduler:{{ .Values.version.k8s }}
    discovery:
        enabled: true
        registries:
            kubernetes:
                disabled: false
            service:
              disabled: true
    etcd:
        ca:
            crt: {{ "{{ .Secrets.certs.etcd.crt }}" }}
            key: {{ "{{ .Secrets.certs.etcd.key }}" }}
    extraManifests: []
    inlineManifests: []
---
apiVersion: v1alpha1
kind: ExtensionServiceConfig
name: nut-client
configFiles:
  - content: |-
        MONITOR opn1.k8s.studiop 1 monuser {{ "{{ .Secrets.nut.password }}" }} secondary
        SHUTDOWNCMD "/sbin/poweroff"
    mountPath: /usr/local/etc/nut/upsmon.conf