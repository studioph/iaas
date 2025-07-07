version: v1alpha1
debug: false
persist: true
machine:
    type: worker
    token: {{ "{{ .Secrets.trustdinfo.token }}" }}
    ca:
        crt: {{ "{{ .Secrets.certs.os.crt }}" }}
        key: ""
    certSANs: []
    kubelet:
        image: ghcr.io/siderolabs/kubelet:{{ .Values.version.k8s }}
        defaultRuntimeSeccompProfileEnabled: true
        disableManifestsDirectory: true
        extraConfig:
          serializeImagePulls: false
    install:
        image: factory.talos.dev/installer/{{ .Values.schematics.nuc.id }}:{{ .Values.version.talos }}
        wipe: false
{{ tmpl.Exec "registries" .Values.registries | indent 4 }}
    features:
        rbac: true
        stableHostname: true
        apidCheckExtKeyUsage: true
        diskQuotaSupport: true
        kubePrism:
            enabled: false
            port: 7445
        hostDNS:
            enabled: true
            forwardKubeDNSToHost: true
    files:
        # Spegel
      - op: create
        path: /etc/cri/conf.d/20-customization.part
        content: |
          [plugins."io.containerd.cri.v1.images"]
            discard_unpacked_layers = false
    udev:
      rules:
        - SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="44", MODE="0660" # Intel GPU
        - ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1" # Thunderbolt
    kernel:
        modules:
          - name: thunderbolt
          - name: thunderbolt_netc
          - name: nvidia
          - name: nvidia_uvm
          - name: nvidia_drm
          - name: nvidia_modeset
          - name: zfs
    sysctls:
      net.core.bpf_jit_harden: 1
    nodeLabels:
      node.kubernetes.io/role: worker
      disktype: nvme
      storagetype: local
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
    ca:
        crt: {{ "{{ .Secrets.certs.k8s.crt }}" }}
        key: ""
    discovery:
        enabled: true
        registries:
            service:
              disabled: true
---
apiVersion: v1alpha1
kind: ExtensionServiceConfig
name: nut-client
configFiles:
  - content: |-
        MONITOR opn1.k8s.studiop 1 monuser {{ "{{ .Secrets.nut.password }}" }} secondary
        SHUTDOWNCMD "/sbin/poweroff"
    mountPath: /usr/local/etc/nut/upsmon.conf