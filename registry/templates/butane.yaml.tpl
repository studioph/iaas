variant: fcos
version: {{ .Values.butane.version }}
storage:
  files:
  {{- range .Values.storage.files.inline }}
    - path: {{ .path }}
      {{- if has . "mode" }}
      mode: {{ printf "%04o" .mode }}
      {{- end }} 
      {{- if has . "contents" }}
      contents:
        inline: {{ .contents }}
      {{- end }}
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
  directories:
  {{- range .Values.storage.folders }}
    - path: {{ .path }}
      mode: 0755
      user:
        name: {{ $.Values.user }}
      group:
        name: {{ $.Values.user }}
  {{- end }}
  links:
  {{- range .Values.storage.links }}
    - path: {{ .path }}
      target: {{ .target }}
      hard: false
      user:
        name: {{ $.Values.user }}
      group:
        name: {{ $.Values.user }}
  {{- end }}
systemd:
  units:
  {{- range .Values.systemd.units }}
    - name: {{ .name }}
      enabled: {{ index . "enabled" | default $.Values.defaults.systemd.enabled }}
    {{- if has . "contents"}}
      contents: |
{{ tmpl.Exec .contents $ | indent 8 }}
    {{- end }}
  {{- end }}

passwd:
  users:
    - name: {{ .Values.user }}
      ssh_authorized_keys:
        - {{ template "files/registry.pub" }}

kernel_arguments:
  should_exist:
    - console=ttyAMA0,115200n8