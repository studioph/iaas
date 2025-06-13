registries:
  mirrors:
    {{- range .remote }}
    {{ .name }}:
      endpoints:
        {{- range $.local }}
        - {{ . }}
        {{- end }}
        - https://{{ index . "remote" | default .name }}
    {{- end }}