# java-in-helm-instrumentation

## How to use:

At first to be able to run `kustomize` executable you have to set execute permissions to `./kustomize/kustomize` file

```
sudo chmod +x ./kustomize/kustomize
```

Then you need to edit `./kustomize/kustomization.yaml` and set right `labelSelector`
Also edit `patch.yaml` to select right container for your application (in our case it is `pet-clinic`)

## How to install:

```
helm install petclinic ../pet-clinic-helm-chart -n petclinic --post-renderer ./kustomize
```

## Hot to upgrade:

```
helm upgrade petclinic ../pet-clinic-helm-chart -n petclinic --post-renderer ./kustomize
```
