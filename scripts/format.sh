#!/usr/bin/env bash

echo "Formatting all terraform files in the repo"

terraform fmt -recursive .
