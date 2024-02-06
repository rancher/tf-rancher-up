#!/bin/sh

set -e

src_dirs=$(find modules recipes -type f -name "main.tf" -exec dirname {} \; | sort -u | grep -v tests)

for src_dir in $src_dirs; do
  echo "Generating docs in dir: $src_dir"
  cd "$src_dir" || exit
  rm -f .terraform.lock.hcl
  terraform-docs markdown . > docs.md
  cd - || exit
done

echo "Generating docs successful"
