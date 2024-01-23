#!/usr/bin/env bash

set -e

src_dirs=$(find modules recipes -type f -name "main.tf" -exec dirname {} \; | sort -u | grep -v tests)

for src_dir in $src_dirs; do
  echo "Generating docs in dir: $src_dir"
  pushd "$src_dir" || exit
  terraform-docs markdown . > docs.md
  popd || exit
done

echo "Generating docs successful"
