#!/bin/sh

apk --no-cache add curl

curl -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.1.0/opentelemetry-javaagent.jar" -o otel-agent.jar
curl -L "https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar" -o dig-ext.jar
curl -L "https://github.com/digma-ai/digma-agent/releases/latest/download/digma-agent.jar" -o dig-agent.jar

cp  otel-agent.jar /shared-vol/otel-agent.jar
cp  dig-agent.jar /shared-vol/dig-agent.jar
cp  dig-ext.jar /shared-vol/dig-ext.jar

# Sleep for debugging purposes
# sleep infinity