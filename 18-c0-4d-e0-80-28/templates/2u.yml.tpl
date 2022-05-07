---
systemd:
  units:
  {{- range .values.systemd.units }}
    - name: {{ .name }}
      enabled: {{ index . "enabled" | default $.global.defaults.systemd.enabled }}
    {{- if has . "contents"}}
      contents: |
{{ tmpl.Exec .contents $ | indent 8 }}
    {{- end }}
  {{- end }}
storage:
  disks:
  {{- range .values.storage.disks }}
    - device: /dev/disk/by-id/{{ .device }}
      wipe_table: {{ index . "wipe" | default $.global.defaults.wipe.partition }}
  {{- end }}
  raid:
  {{- range $key, $value := .values.storage.raid }}
    - name: {{ $key }}
      level: {{ $value.level }}
      devices:
        {{- range $value.disks }}
        - /dev/disk/by-id/{{ . }}-part1
        {{- end }}
  {{- end }}
  filesystems:
    {{- range $key, $value := .values.storage.filesystems }}
    - name: {{ $key }}
      mount:
        device: {{ $value.device }}
        format: {{ index $value "format" | default $.global.defaults.storage.format }}
        wipe_filesystem: {{ index . "wipe" | default $.global.defaults.wipe.filesystem }}
        {{- if has . "label" }}
        label: {{ $value.label }}
        {{- end }}
    {{- end }}
  directories:
  {{- range .values.storage.folders }}
    - path: {{ .path }}
      filesystem: {{ index . "filesystem" | default $.global.defaults.storage.filesystem }}
  {{- end }}
  files:
    - path: /etc/ssh/sshd_config
      filesystem: root
      mode: 0600
      contents:
        inline: |
{{ tmpl.Exec "files/sshd_config" . | indent 10 }}
  {{- range .values.storage.files.remote }}
    - path: {{ .path }}
      filesystem: {{ index . "filesystem" | default $.global.defaults.storage.filesystem }}
      {{- if has . "mode" }}
      mode: {{ printf "%04o" .mode }}
      {{- end }} 
      contents:
        remote:
          url: {{ .url }}
  {{- end }}
    - path: /etc/hostname
      filesystem: root
      mode: 0644
      contents:
        inline: flatcar
  links:
  {{- range .values.storage.links }}
    - path: {{ .path }}
      target: {{.target }}
      filesystem: {{ index . "filesystem" | default $.global.defaults.storage.filesystem }}
  {{- end }}
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - {{ template "files/flatcar.pub" }}
networkd:
  units:
  {{- range .values.networkd.units }}
    - name: {{ .name }}
      contents: |
{{ tmpl.Exec .contents $ | indent 8 }}
  {{- end }}