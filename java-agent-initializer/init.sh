#!/bin/sh

apk --no-cache add curl

curl -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.1.0/opentelemetry-javaagent.jar" -o opentelemetry-javaagent.jar
curl -L "https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar" -o digma-otel-agent-extension.jar

cp  opentelemetry-javaagent.jar /shared/java-agent/opentelemetry-javaagent.jar
cp  digma-otel-agent-extension.jar /shared/java-agent/digma-otel-agent-extension.jar

# Sleep for debugging purposes
# sleep infinity