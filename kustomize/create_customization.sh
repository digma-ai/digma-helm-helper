#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <DIGMA_OTLP_ENDPOINT> <SERVICE_NAME> <ENVIRONMENT_ID> <LABEL_TARGET_SELECTOR>"
    echo "Example: $0 http://my.digma.collector:5050 clinic-service perf-tests#ID#1 app=pet-clinic-app"
    exit 1
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    usage
fi

current_dir=$(pwd)

# Get the script's directory by extracting the directory part from $0
script_dir=$(cd "$(dirname "$0")" && pwd)

# Assign arguments to variables
DIGMA_OTLP_ENDPOINT=$1
SERVICE_NAME=$2
ENVIRONMENT_NAME=$3
LABEL_TARGET_SELECTOR=$4

SERVICE_OTEL_RESOURCE_ATTRIBUTES="digma.environment=$ENVIRONMENT_NAME,digma.environment.type=Public"

original_file="${script_dir}/kustomization.yaml"

new_file="./kustomization.yaml"

temp_file=$(mktemp)

# Ensure temporary file gets deleted on script exit
trap 'rm -f "$temp_file"' EXIT

# Update kustomization.yaml with the provided arguments using a temp file for compatibility
sed "s|<DIGMA_OTLP_ENDPOINT>|$DIGMA_OTLP_ENDPOINT|g" "$original_file" > "$temp_file" && mv "$temp_file" "$new_file"
sed "s|<SERVICE_NAME>|$SERVICE_NAME|g" "$original_file" > "$temp_file" && mv "$temp_file" "$new_file"
sed "s|<SERVICE_OTEL_RESOURCE_ATTRIBUTES>|$SERVICE_OTEL_RESOURCE_ATTRIBUTES|g" "$original_file" > "$temp_file" && mv "$temp_file" "$new_file"
sed "s|<LABEL_TARGET_SELECTOR>|$LABEL_TARGET_SELECTOR|g" "$original_file" > "$temp_file" && mv "$temp_file" "$new_file"

# Copy the original file to a new file
cp "${script_dir}/patch.yaml" "./patch.yaml"


echo "kustomization.yaml has been updated."
