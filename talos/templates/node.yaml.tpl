machine:
  install:
    diskSelector:
      wwid: {{ .install_disk }}
  network:
    hostname: {{ .hostname }}
    interfaces:
{{- range .interfaces }}
      - deviceSelector:
          hardwareAddr: {{ .mac }}
        dhcp: true
  {{- if  (has . "vip") }}
        vip:
          ip: {{ .vip }}
  {{- end }}
{{- end }}
{{- if (has . "annotations") }}
  nodeAnnotations:
    {{ .annotations | toYAML }}
{{- end }}