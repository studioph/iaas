customization:
{{- if has . "extraKernelArgs" }}
  extraKernelArgs:
{{ .extraKernelArgs | toYAML | indent 4 }}
{{- end }}
  systemExtensions:
    officialExtensions:
{{ .extensions | toYAML | indent 6 }}