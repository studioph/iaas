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
        - {{ template "files/iaas.pub" }}
      groups:
        - docker

kernel_arguments:
  should_exist:
    - console=ttyAMA0,115200n8