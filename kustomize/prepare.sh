#!/bin/bash

export DIGMA_OTLP_ENDPOINT=your_endpoint:port
export SERVICE_NAME=service_name
export SERVICE_OTEL_RESOURCE_ATTRIBUTES=digma.environment.id=PETCLINIC
export LABEL_TARGET_SELECTOR=app=pet-clinic-app

sed -i '' "s/<DIGMA_OTLP_ENDPOINT>/$DIGMA_OTLP_ENDPOINT/g" ./kustomization.yaml
sed -i ''  "s/<SERVICE_NAME>/$SERVICE_NAME/g" ./kustomization.yaml
sed -i '' "s/<SERVICE_OTEL_RESOURCE_ATTRIBUTES>/$SERVICE_OTEL_RESOURCE_ATTRIBUTES/g" ./kustomization.yaml
sed -i '' "s/<LABEL_TARGET_SELECTOR>/$LABEL_TARGET_SELECTOR/g" ./kustomization.yaml