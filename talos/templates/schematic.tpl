{{- range $key, $value := .Values.schematics -}}
{{- $outPath := printf "schematics/%s.yaml" $key }}
{{- tmpl.Exec "schematic" $value | file.Write $outPath -}}
{{- end -}}