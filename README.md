# java-in-helm-instrumentation

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
