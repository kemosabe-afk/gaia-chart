# Gaia Helm Chart

This Helm chart deploys Gaia, Gaia Runner, and MongoDB in a Kubernetes cluster.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## Prerequisites

- Kubernetes 1.22+
- Helm 3.8+

## Installation

Clone the repository:

```sh
git clone https://github.com/kemosabe-afk/gaia-chart.git
```

You can specify a namespace for the app using `-n <namespace> --create-namespace`, otherwise it will be created in the default namespace.

If you are installing multiple releases, change the `database.volume.storagePath` parameter in the *values.yaml* file to create a directory for another PV for MongoDB.

Install the Helm chart:

```sh
helm install <release-name> ./gaia-chart
```

## Configuration

The following table lists the configurable parameters of the Gaia chart and their default values.

| Parameter               | Description                                      | Default      |
|-------------------------|--------------------------------------------------|--------------|
| `gaia.replicaCount`     | Number of Gaia Deployment Replicas               | `1`          |
| `runner.replicaCount`   | Number of Gaia Runner Deployment Replicas        | `1`          |
| `database.replicaCount` | Number of MongoDB Deployment Replicas            | `1`          |
| `namespace`             | The Namespace for Release Installation           | `gaia`       |
| `serviceAccount.name`   | The Service Account Used by Gaia                 | `gaia`       |

See `values.yaml` for more details.

## Usage

After installing the Helm chart, you can access the Gaia application using the Gaia service name and port:

```
http://<service-name>:<port>
```

Default login credentials:

- Username: admin
- Password: admin123

## Troubleshooting

If you encounter any issues with the deployment, check the logs of the pods:

```sh
kubectl logs <pod-name>
```
