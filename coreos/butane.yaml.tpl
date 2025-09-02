variant: fcos
version: 1.6.0
systemd:
  units:
    - name: podman.service
      enabled: true
    - name: podman.socket
      enabled: true
    - name: serial-getty@ttyS0.service
      enabled: true
    - name: rpm-ostree-countme.service
      enabled: false
    - name: rpm-ostree-countme.timer
      enabled: false
    - name: install-packages.service
      enabled: true
      contents: |
        {{ tmpl.Exec "units/install-packages.service" | indent 8 | trimSpace }}
    - name: var-mnt-media.mount
      enabled: true
      contents: |
        {{ tmpl.Exec "units/var-mnt-media.mount" | indent 8 | trimSpace }}
    - name: var-mnt-downloads.mount
      enabled: true
      contents: |
        {{ tmpl.Exec "units/var-mnt-downloads.mount" | indent 8 | trimSpace }}
storage:
  files:
    - path: /etc/selinux/config
      mode: 0600
      overwrite: true
      contents:
        inline: |
          {{ tmpl.Exec "files/selinux.config" | indent 10 | trimSpace }}
    - path: /etc/NetworkManager/system-connections/1g.nmconnection
      mode: 0600
      contents:
        inline: |
          {{ tmpl.Exec "files/1g.ini" | indent 10 | trimSpace }}
    - path: /etc/NetworkManager/system-connections/10g.nmconnection
      mode: 0600
      contents:
        inline: |
          {{ tmpl.Exec "files/10g.ini" | indent 10 | trimSpace }}
    - path: /etc/sysctl.d/20-silence-audit.conf
      contents:
        inline: kernel.printk=4
    - path: /etc/hostname
      contents:
        inline: coreos
    - path: /etc/zincati/config.d/51-rollout-wariness.toml
      contents:
        inline: |
          {{ tmpl.Exec "files/wariness.toml" | indent 10 | trimSpace }}
    - path: /etc/zincati/config.d/55-updates-strategy.toml
      contents:
        inline: |
          {{ tmpl.Exec "files/updates.toml" | indent 10 | trimSpace }}
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - {{ tmpl.Exec "files/coreos.pub" }}
      groups:
        - docker