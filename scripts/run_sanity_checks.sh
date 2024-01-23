#!/usr/bin/env sh

set -e

TESTS_ROOT_DIR=${1:-"tests"}

tests_dirs=$(find "$TESTS_ROOT_DIR" -type f -name "main.tf" -exec dirname {} \; | sort -u | grep -v digitalocean)

for test_dir in $tests_dirs; do
  echo "Running tests in dir: $test_dir"
  cd "$test_dir"
  terraform init
  terraform plan -out=/dev/null
  cd -
done

echo "Running tests successful"
