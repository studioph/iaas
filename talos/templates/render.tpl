{{- range $key, $value := .Values.nodes.worker -}}
{{- $outPath := printf "patches/%s.yaml" $key }}
{{- $value | set "hostname" $key | tmpl.Exec "node" | file.Write $outPath }}
{{- end -}}

{{- range $key, $value := .Values.nodes.control_plane -}}
{{- $outPath := printf "patches/%s.yaml" $key }}
{{- $value | set "hostname" $key | tmpl.Exec "node" | file.Write $outPath }}
{{- end -}}

