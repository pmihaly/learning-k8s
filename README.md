# learning-k8s


Tools to be tried out:

- [x] Kustomize - Templating
- [x] Skaffold - Local development
- [ ] ArgoCD - syncing manifest change to deployed clusters
- [ ] Crossplane - IaC
- [ ] Prometheus & Grafana - Metrics & Monitoring
- [ ] CertManager - TLS Certs
- [ ] Lstio - Service Mesh
- [ ] Loki & Promtail - Logging

Deploy prod:
``
kubectl apply -k k8s/environments/prod
``
Run dev (watch files):
``
skaffold dev
``
