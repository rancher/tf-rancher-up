#!/usr/bin/env bash

set -e

TESTS_ROOT_DIR=${1:-"tests"}

tests_dirs=$(find "$TESTS_ROOT_DIR" -type f -name "main.tf" -exec dirname {} \; | sort -u | grep -v digitalocean)

for test_dir in $tests_dirs; do
  echo "Running tests in dir: $test_dir"
  cd "$test_dir"
  terraform init
  if [[ $test_dir == *"gke"* ]] || [[ $test_dir == *"google-cloud"* ]]; then
    sed -i "s/project-test/$GOOGLE_PROJECT/g" ./variables.tf
    touch gke-test-ssh_public_key.pem
    touch gke-test-ssh_private_key.pem
  fi
  terraform plan -out=/dev/null
  cd -
done

echo "Running tests successful"
