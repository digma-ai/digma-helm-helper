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
