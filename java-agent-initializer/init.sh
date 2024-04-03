#!/bin/sh

apk --no-cache add curl

curl -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.1.0/opentelemetry-javaagent.jar" -o otel-agent.jar
curl -L "https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar" -o dig-ext.jar

cp  otel-agent.jar /shared-vol/otel-agent.jar
cp  dig-ext.jar /shared-vol/dig-ext.jar

# Sleep for debugging purposes
# sleep infinity