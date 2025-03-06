#!/bin/ash
set -e

# Install curl if not already available
apk --no-cache add curl

# Define environment variables for versions (default to "latest" if not set)
OTEL_AGENT_VERSION=${OTEL_AGENT_VERSION:-"2.10.0"}
DIG_AGENT_VERSION=${DIG_AGENT_VERSION:-"2.0.4"}
DIG_EXT_VERSION=${DIG_EXT_VERSION:-"2.10.1"}

if [ "$OTEL_AGENT_VERSION" = "latest" ]; then
    OTEL_AGENT_URL="https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar"
else
    OTEL_AGENT_URL="https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_AGENT_VERSION}/opentelemetry-javaagent.jar"
fi

if [ "$DIG_AGENT_VERSION" = "latest" ]; then
    DIG_AGENT_URL="https://github.com/digma-ai/digma-agent/releases/latest/download/digma-agent.jar"
else
    DIG_AGENT_URL="https://github.com/digma-ai/digma-agent/releases/download/v${DIG_AGENT_VERSION}/digma-agent.jar"
fi

if [ "$DIG_EXT_VERSION" = "latest" ]; then
    DIG_EXT_URL="https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar"
else
    DIG_EXT_URL="https://github.com/digma-ai/otel-java-instrumentation/releases/download/v${DIG_EXT_VERSION}/digma-otel-agent-extension.jar"
fi

# Download the files
echo "Downloading OpenTelemetry Java Agent from: $OTEL_AGENT_URL"
curl -L --fail --show-error "$OTEL_AGENT_URL" -o otel-agent.jar

echo "Downloading Digma Agent from: $DIG_AGENT_URL"
curl -L --fail --show-error "$DIG_AGENT_URL" -o dig-agent.jar

echo "Downloading Digma OTEL Agent Extension from: $DIG_EXT_URL"
curl -L --fail --show-error "$DIG_EXT_URL" -o dig-ext.jar


# Copy files to shared volume
cp otel-agent.jar /shared-vol/otel-agent.jar
cp dig-agent.jar /shared-vol/dig-agent.jar
cp dig-ext.jar /shared-vol/dig-ext.jar

# Sleep for debugging purposes (optional)
# sleep infinity
