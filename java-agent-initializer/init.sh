#!/bin/ash
set -e

# Install curl if not already available
apk --no-cache add curl

# Define environment variables for versions (default to "latest" if not set)
OTEL_VERSION=${OTEL_VERSION:-"2.1.0"}
DIG_EXT_VERSION=${DIG_EXT_VERSION:-"latest"}
DIG_AGENT_VERSION=${DIG_AGENT_VERSION:-"latest"}

OTEL_URL="https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_VERSION}/opentelemetry-javaagent.jar"

if [ "$DIG_EXT_VERSION" = "latest" ]; then
    DIG_EXT_URL="https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar"
else
    DIG_EXT_URL="https://github.com/digma-ai/otel-java-instrumentation/releases/download/v${DIG_EXT_VERSION}/digma-otel-agent-extension.jar"
fi

if [ "$DIG_AGENT_VERSION" = "latest" ]; then
    DIG_AGENT_URL="https://github.com/digma-ai/digma-agent/releases/latest/download/digma-agent.jar"
else
    DIG_AGENT_URL="https://github.com/digma-ai/digma-agent/releases/download/v${DIG_AGENT_VERSION}/digma-agent.jar"
fi

# Download the files
echo "Downloading OpenTelemetry Java Agent from: $OTEL_URL"
curl -L --fail --show-error "$OTEL_URL" -o otel-agent.jar

echo "Downloading Digma OTEL Agent Extension from: $DIG_EXT_URL"
curl -L --fail --show-error "$DIG_EXT_URL" -o dig-ext.jar

echo "Downloading Digma Agent from: $DIG_AGENT_URL"
curl -L --fail --show-error "$DIG_AGENT_URL" -o dig-agent.jar

# Copy files to shared volume
cp otel-agent.jar /shared-vol/otel-agent.jar
cp dig-agent.jar /shared-vol/dig-agent.jar
cp dig-ext.jar /shared-vol/dig-ext.jar

# Sleep for debugging purposes (optional)
# sleep infinity
