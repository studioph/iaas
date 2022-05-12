variant: fcos
version: {{ .Values.butane.version }}

storage:
  disks:
    - device: /dev/disk/by-id/{{ .Values.storage.disks.docker.device }}
      wipe_table: {{ .Values.global.defaults.wipe.partition }}
      partitions:
        - label: docker
  filesystems:
    - device: /dev/disk/by-id/{{ .Values.storage.disks.docker.device }}-part1
      format: {{ .Values.global.defaults.storage.format }}
      wipe_filesystem: {{ .Values.global.defaults.wipe.filesystem }}
      path: /var/lib/docker
      with_mount_unit: true
  files:
    - path: /opt/bin/docker-compose
      mode: 0755
      contents:
        source: https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64
    - path: /opt/docker-compose/portainer.yml
      contents:
        source: https://raw.githubusercontent.com/paulhutchings/compose/master/portainer.yml
    - path: {{ .Values.network.file_prefix }}/1g.nmconnection
      mode: 0600
      contents:
        inline: |
{{ tmpl.Exec "files/1g.network" . | indent 10 }}
    - path: {{ .Values.network.file_prefix }}/10g.nmconnection
      mode: 0600
      contents:
        inline: |
{{ tmpl.Exec "files/10g.network" . | indent 10 }}
    - path: /etc/ssh/sshd_config
      mode: 0600
      contents:
        inline: |
{{ tmpl.Exec "files/sshd_config" . | indent 10 }}

systemd:
  units:
    - name: docker.service
      enabled: true

passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - {{ template "files/flatcar.pub" }}