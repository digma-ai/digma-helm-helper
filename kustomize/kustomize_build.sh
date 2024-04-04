#!/bin/bash

cat <&0 > generated-chart-output.yaml

kustomize build . && rm generated-chart-output.yaml