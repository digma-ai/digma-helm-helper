# digma-helm-helper

This repo contains helpers to instrument an application running in a Helm file - without changing the original Helm file.

## Prerequisite

Kustomize cli should be installed (https://kustomize.io/)

## How to use:

For a full walkthrough see our [documentation](https://docs.digma.ai/digma-developer-guide/instrumentation/spring-spring-boot-dropwizard-and-default/instrumenting-your-application-on-kubernetes)

## What's in this repo
* `example-app` An example application to test the kustomize script on
* `java-agent-initializer` The source code of the init container used to provide the agent files
* `kustomize` scripts used to prepare the patch for you application Helm file


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


Kustomize updates only the first container of my deployment.

We assume you have only one container per deployment configuration, if it's not true for you, you need to duplicate patch `https://github.com/digma-ai/java-in-helm-instrumentation/blob/main/kustomize/kustomization.yaml#L9` section and and change duplicated lines `11,27,32` with next number of your container (to `1`, means second container). 

Example: 
```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - generated-chart-output.yaml
patches:
  - path: patch.yaml
    target:
      labelSelector: <LABEL_TARGET_SELECTOR>
  - patch: |-
      - op: add
        path: "/spec/template/spec/containers/0/env/-"
        value:
          name: JAVA_TOOL_OPTIONS
          value: >-
            -javaagent:/shared-vol/otel-agent.jar 
            -Dotel.javaagent.extensions=/shared-vol/digma-ext.jar 
            -Dotel.exporter.otlp.traces.endpoint=<DIGMA_OTLP_ENDPOINT>
            -Dotel.traces.exporter=otlp 
            -Dotel.metrics.exporter=none 
            -Dotel.logs.exporter=none 
            -Dotel.exporter.otlp.protocol=grpc 
            -Dotel.instrumentation.common.experimental.controller.telemetry.enabled=true 
            -Dotel.instrumentation.common.experimental.view.telemetry.enabled=true 
            -Dotel.instrumentation.experimental.span-suppression-strategy=none 
            -Dotel.service.name=<SERVICE_NAME>
      - op: add
        path: "/spec/template/spec/containers/0/env/-"
        value:
          name: OTEL_RESOURCE_ATTRIBUTES
          value: <SERVICE_OTEL_RESOURCE_ATTRIBUTES>
      - op: add
        path: "/spec/template/spec/containers/0/volumeMounts/-"
        value:
          name: shared
          mountPath: /shared-vol
      - op: add
        path: "/spec/template/spec/containers/1/env/-"
        value:
          name: JAVA_TOOL_OPTIONS
          value: >-
            -javaagent:/shared-vol/otel-agent.jar 
            -Dotel.javaagent.extensions=/shared-vol/digma-ext.jar 
            -Dotel.exporter.otlp.traces.endpoint=<DIGMA_OTLP_ENDPOINT>
            -Dotel.traces.exporter=otlp 
            -Dotel.metrics.exporter=none 
            -Dotel.logs.exporter=none 
            -Dotel.exporter.otlp.protocol=grpc 
            -Dotel.instrumentation.common.experimental.controller.telemetry.enabled=true 
            -Dotel.instrumentation.common.experimental.view.telemetry.enabled=true 
            -Dotel.instrumentation.experimental.span-suppression-strategy=none 
            -Dotel.service.name=<SERVICE_NAME>
      - op: add
        path: "/spec/template/spec/containers/1/env/-"
        value:
          name: OTEL_RESOURCE_ATTRIBUTES
          value: <SERVICE_OTEL_RESOURCE_ATTRIBUTES>
      - op: add
        path: "/spec/template/spec/containers/1/volumeMounts/-"
        value:
          name: shared
          mountPath: /shared-vol
    target:
      labelSelector: <LABEL_TARGET_SELECTOR>
```
