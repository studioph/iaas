apiVersion: v1
kind: Pod
metadata:
  name: registry
spec:
  containers:
    - name: {{ .Values.proxy.container.name }}
      image: {{ .Values.proxy.image.name }}:{{ .Values.proxy.image.tag }}
      ports:
        - name: http
          containerPort: {{ .Values.proxy.ports.container }}
          hostPort: {{ .Values.proxy.ports.host }}
      volumeMounts:
        - name: proxy-config
          mountPath: {{ .Values.proxy.config.mountPath }}
          readOnly: {{ .Values.proxy.config.readOnly }}
      resources:
        requests:
          cpu: {{ .Values.proxy.resources.cpu.request }}
          memory: {{ .Values.proxy.resources.memory.request }}
        limits:
          cpu: {{ .Values.proxy.resources.cpu.limit }}
          memory: {{ .Values.proxy.resources.memory.request }}

    - name: {{ .Values.registry.container.name }}
      image: {{ .Values.registry.image.name }}:{{ .Values.registry.image.tag }}
      args:
        - --listen
        - 0.0.0.0:{{ .Values.registry.port }}
        - filesystem
        - --root
        - {{ .Values.registry.storage.mountPath }}
      volumeMounts:
        - name: registry-data
          mountPath: {{ .Values.registry.storage.mountPath }}
      resources:
        requests:
          cpu: {{ .Values.registry.resources.cpu.request }}
          memory: {{ .Values.registry.resources.memory.request }}
        limits:
          cpu: {{ .Values.registry.resources.cpu.limit }}
          memory: {{ .Values.registry.resources.memory.request }}

  volumes:
    - name: proxy-config
      configMap:
        name: registry-proxy
        optional: false
        items:
          - key: default.conf
            path: default.conf.template
    - name: registry-data
      persistentVolumeClaim:
        claimName: registry-data
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: registry-proxy
data:
  default.conf: |
    server {
        listen {{ .Values.proxy.ports.container }};
        server_name {{ .Values.hostname }};

        location /v2/ {
            proxy_pass http://{{ .Values.registry.container.name }}:{{ .Values.registry.port }}/v2/;
        }

        location ~ "/v2/([A-z0-9-_~]+?\.[A-z0-9-_~]+?)/(.*)" {
            proxy_pass http://{{ .Values.registry.container.name }}:{{ .Values.registry.port }}/v2/$2?ns=$1;
        }

        location ~ "/([A-z0-9-_~]+?\.[A-z0-9-_~]+?)/v2/(.*)" {
            proxy_pass http://{{ .Values.registry.container.name }}:{{ .Values.registry.port }}/v2/$2?ns=$1;
        }
    }
