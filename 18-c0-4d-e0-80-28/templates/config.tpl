---
systemd:
  units:
  {{- range .Values.systemd.units }}
    - name: {{ .name }}
      enabled: {{ index . "enabled" | default $.Values.global.defaults.systemd.enabled }}
    {{- if has . "contents"}}
      contents: |
{{ tmpl.Exec .contents $ | indent 8 }}
    {{- end }}
    {{- if has . "dropins" }}
      dropins:
      {{- range .dropins }}
        - name: {{ .name }}
          contents: |
{{ tmpl.Exec .contents $ | indent 12 }}
      {{- end }}
    {{- end }}  
  {{- end }}
storage:
  disks:
  {{- range .Values.storage.disks }}
    - device: /dev/disk/by-id/{{ .device }}
      wipe_table: {{ index . "wipe" | default $.Values.global.defaults.wipe.partition }}
      partitions:
      {{- range .partitions }}
        - label: {{ .label }}
      {{- end }}
  {{- end }}
  raid:
  {{- range $key, $value := .Values.storage.raid }}
    - name: {{ $key }}
      level: {{ $value.level }}
      devices:
        {{- range $value.disks }}
        - /dev/disk/by-id/{{ . }}-part1
        {{- end }}
  {{- end }}
  filesystems:
    {{- range $key, $value := .Values.storage.filesystems }}
    - name: {{ $key }}
      mount:
        device: {{ $value.device }}
        format: {{ index $value "format" | default $.Values.global.defaults.storage.format }}
        wipe_filesystem: {{ index . "wipe" | default $.Values.global.defaults.wipe.filesystem }}
        {{- if has . "label" }}
        label: {{ $value.label }}
        {{- end }}
    {{- end }}
  directories:
  {{- range .Values.storage.folders }}
    - path: {{ .path }}
      filesystem: {{ index . "filesystem" | default $.Values.global.defaults.storage.filesystem }}
  {{- end }}
  files:
    - path: /etc/ssh/sshd_config
      filesystem: root
      mode: 0600
      contents:
        inline: |
{{ tmpl.Exec "files/sshd_config" . | indent 10 }}
  {{- range .Values.storage.files.remote }}
    - path: {{ .path }}
      filesystem: {{ index . "filesystem" | default $.Values.global.defaults.storage.filesystem }}
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
        inline: {{ .Values.hostname }}
  links:
  {{- range .Values.storage.links }}
    - path: {{ .path }}
      target: {{.target }}
      filesystem: {{ index . "filesystem" | default $.Values.global.defaults.storage.filesystem }}
  {{- end }}
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - {{ template "files/flatcar.pub" }}
networkd:
  units:
  {{- range .Values.networkd.units }}
    - name: {{ .name }}
      contents: |
{{ tmpl.Exec .contents $ | indent 8 }}
  {{- end }}