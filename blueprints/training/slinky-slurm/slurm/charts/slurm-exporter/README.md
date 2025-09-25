# slurm-exporter

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 25.05](https://img.shields.io/badge/AppVersion-25.05-informational?style=flat-square)

Slurm Metrics Prometheus Exporter

**Homepage:** <https://slinky.schedmd.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| SchedMD LLC. | <slinky@schedmd.com> | <https://support.schedmd.com/> |

## Source Code

* <https://github.com/SlinkyProject/slurm-exporter>

## Requirements

Kubernetes: `>= 1.29`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.affinity | object | `{}` |  Set affinity for Kubernetes Pod scheduling. Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity |
| exporter.cacheFrequency | string | `"5s"` |  The amount of time to wait between updating the Slurm restapi cache. Must be greater than 1s and must be parsable by `time.ParseDuration`. |
| exporter.enabled | bool | `true` |  Enables metrics collection. |
| exporter.image.repository | string | `"ghcr.io/slinkyproject/slurm-exporter"` |  Set the image repository to use. |
| exporter.image.tag | string | The chart Version. |  Set the image tag to use. |
| exporter.imagePullPolicy | string | `"IfNotPresent"` |  Set the image pull policy. |
| exporter.logLevel | string | `"info"` |  Set the log level by string (e.g. error, info, debug) or number (e.g. 1..5). |
| exporter.priorityClassName | string | `""` |  Set the priority class to use. Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass |
| exporter.replicas | integer | `1` |  Set the number of replicas to deploy. |
| exporter.resources | object | `{}` |  Set container resource requests and limits for Kubernetes Pod scheduling. Ref: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-requests-and-limits-of-pod-and-container |
| exporter.secretName | string | `""` |  The name of the secret containing a token to communicate with the Slurm REST API. |
| exporter.serviceMonitor.enabled | bool | `true` |  |
| exporter.serviceMonitor.endpoints[0].interval | string | `"10s"` |  |
| exporter.serviceMonitor.endpoints[0].path | string | `"/metrics"` |  |
| exporter.serviceMonitor.endpoints[0].port | string | `"metrics"` |  |
| exporter.serviceMonitor.endpoints[0].scheme | string | `"http"` |  |
| exporter.tolerations | object | `[]` |  Set tolerations for Kubernetes Pod scheduling. Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/ |
| grafana.enabled | bool | `true` |  Enables grafana dashboard. |
| imagePullSecrets | list | `[]` |  Set the secrets for image pull. Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| nameOverride | string | `""` |  Overrides the name of the release. |
| namespaceOverride | string | `""` |  Overrides the namespace of the release. |
| priorityClassName | string | `""` |  Set the priority class to use. Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass |

