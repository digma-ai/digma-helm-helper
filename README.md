# java-in-helm-instrumentation

## Prerequisite

Kustomize cli should be installed (https://kustomize.io/)

## How to use:

At first to be able to run `kustomize` executable you have to set execute permissions to `./kustomize/*` files

```
sudo chmod +x ./kustomize/kustomize_build.sh
sudo chmod +x ./kustomize/prepare.sh
```

Then you need to update `prepare.sh` file with your export variables and run

```
cd ./kustomize
./prepare.sh
```

### Content of `prepare.sh`
```
#!/bin/bash

export DIGMA_OTLP_ENDPOINT=your_endpoint:port
export SERVICE_NAME=service_name
export SERVICE_OTEL_RESOURCE_ATTRIBUTES=digma.environment=PETCLINIC
export LABEL_TARGET_SELECTOR=app=pet-clinic-app

sed -i '' "s/<DIGMA_OTLP_ENDPOINT>/$DIGMA_OTLP_ENDPOINT/g" ./kustomization.yaml
sed -i '' "s/<SERVICE_NAME>/$SERVICE_NAME/g" ./kustomization.yaml
sed -i '' "s/<SERVICE_OTEL_RESOURCE_ATTRIBUTES>/$SERVICE_OTEL_RESOURCE_ATTRIBUTES/g" ./kustomization.yaml
sed -i '' "s/<LABEL_TARGET_SELECTOR>/$LABEL_TARGET_SELECTOR/g" ./kustomization.yaml
```

Double check that all variables were substituted in the `./kustomize/kustomization.yaml` file.
List: `<DIGMA_OTLP_ENDPOINT>, <SERVICE_OTEL_RESOURCE_ATTRIBUTES>, <SERVICE_NAME>, <LABEL_TARGET_SELECTOR>`

## Hot to test and check configuration:

```
cd ./kustomize
helm template petclinic ../pet-clinic-helm-chart -n petclinic --post-renderer ./kustomize_build.sh --debug --dry-run
```

## How to install:

```
cd ./kustomize
helm install petclinic ../pet-clinic-helm-chart -n petclinic --post-renderer ./kustomize_build.sh
```

## Hot to upgrade:

```
cd ./kustomize
helm upgrade petclinic ../pet-clinic-helm-chart -n petclinic --post-renderer ./kustomize_build.sh
```
# Troubleshooting

You got:
```
Error: error while running post render on files: error while running command /java-in-helm-instrumentation/kustomize/kustomize_build.sh. error output:
Error: add operation does not apply: doc is missing path: "/spec/template/spec/containers/0/volumeMounts/-": missing value
: exit status 1
helm.go:84: [debug] exit status 1
error while running command /java-in-helm-instrumentation/kustomize/kustomize_build.sh. error output:
Error: add operation does not apply: doc is missing path: "/spec/template/spec/containers/0/volumeMounts/-": missing value
```
The problem is that your `volumeMounts` for your container is empty and kustomize cannot add it. 

How to fix: change line `https://github.com/digma-ai/java-in-helm-instrumentation/blob/main/kustomize/kustomization.yaml#L32` from `path: "/spec/template/spec/containers/0/volumeMounts/-"` to `path: "/spec/template/spec/containers/0/volumeMounts"`
