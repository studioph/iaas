---
variant: fcos
version: {{ .Values.global.butane.version }}
systemd:
  units:
  {{- range .Values.systemd.units }}
    - name: {{ .name }}
      enabled: {{ index . "enabled" | default $.Values.global.defaults.systemd.enabled }}
    {{- if has . "contents"}}
      contents: |
{{ tmpl.Exec .contents $ | indent 8 }}
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
  {{- range .Values.storage.raid }}
    - name: {{ .name }}
      level: {{ .level }}
      devices:
      {{- range .disks }}
        - /dev/disk/by-id/{{ . }}-part1
      {{- end }}
  {{- end }}
  filesystems:
    {{- range .Values.storage.filesystems }}
    - path: {{ .path }}
      device: {{ .device }}
      format: {{ index . "format" | default $.Values.global.defaults.storage.format }}
      wipe_filesystem: {{ index . "wipe" | default $.Values.global.defaults.wipe.filesystem }}
      {{- if has . "label" }}
      label: {{ .label }}
      {{- end }}
      with_mount_unit: true
    {{- end }}
  files:
  {{- range .Values.storage.files.inline }}
    - path: {{ .path }}
      {{- if has . "mode" }}
      mode: {{ printf "%04o" .mode }}
      {{- end }} 
      contents:
        inline: {{ .contents }}
  {{- end }}
  {{- range .Values.storage.files.remote }}
    - path: {{ .path }}
      {{- if has . "mode" }}
      mode: {{ printf "%04o" .mode }}
      {{- end }} 
      contents:
        source: {{ .url }}
  {{- end }}
  {{- range .Values.storage.files.template }}
    - path: {{ .path }}
      {{- if has . "mode" }}
      mode: {{ printf "%04o" .mode }}
      {{- end }}
      {{- if has . "overwrite" }}
      overwrite: {{ .overwrite }}
      {{- end }} 
      contents:
        inline: |
{{ tmpl.Exec .contents $ | indent 10 }}
  {{- end }}
passwd:
  users:
    - name: {{ .Values.global.docker.user }}
      ssh_authorized_keys:
        - {{ template "files/coreos.pub" }}