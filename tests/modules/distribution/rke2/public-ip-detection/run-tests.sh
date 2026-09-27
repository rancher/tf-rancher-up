#!/usr/bin/env bash
# Tests the public/private IP detection at the top of the RKE2 user-data templates
# (modules/distribution/rke2/*_config.yaml.tpl): everything before config.yaml is written.
# That block is plain bash with no template interpolation, so it runs directly with fake
# curl, ip and sleep commands (./fakes). No cloud resources or Terraform needed.
#
# Usage: ./run-tests.sh [template ...]   (default: the server and worker templates)

set -u
DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$DIR/../../../../.." && pwd)
if [ $# -eq 0 ]; then
  set -- "$REPO_ROOT/modules/distribution/rke2/server_config.yaml.tpl" \
         "$REPO_ROOT/modules/distribution/rke2/worker_config.yaml.tpl"
fi

pass=0
fail=0

# check <name> <curl results> <expected exit> <expected PUBLIC_IP> <expected PRIVATE_IP>
check() {
  local block=$1 name=$2 want_rc=$4 want="PUBLIC_IP=[$5] PRIVATE_IP=[$6]" out rc calls
  export CURL_SCRIPT=$3 CALLS_FILE
  CALLS_FILE=$(mktemp)
  out=$(PATH="$DIR/fakes:$PATH" bash -c "$block"$'\necho "PUBLIC_IP=[$PUBLIC_IP] PRIVATE_IP=[$PRIVATE_IP]"' 2>&1)
  rc=$?
  calls=$(cat "$CALLS_FILE")
  rm -f "$CALLS_FILE"
  if [ "$rc" -eq "$want_rc" ] && { [ "$want_rc" -ne 0 ] || grep -qF "$want" <<<"$out"; }; then
    pass=$((pass + 1))
    echo "PASS  $name (exit $rc, $calls lookups)"
  else
    fail=$((fail + 1))
    echo "FAIL  $name: want exit $want_rc $want; got exit $rc after $calls lookups: $(tail -1 <<<"$out")"
  fi
}

for template in "$@"; do
  echo "== ${template#"$REPO_ROOT"/}"
  block=$(sed '/^cat > \/tmp\/config.yaml/,$d' "$template")
  check "$block" "lookup succeeds first time"      "ok"           0 203.0.113.10 10.124.0.4
  check "$block" "transient failures then success" "fail fail ok" 0 203.0.113.10 10.124.0.4
  check "$block" "error page then success"         "html ok"      0 203.0.113.10 10.124.0.4
  check "$block" "lookup never succeeds"           "fail"         1 "" ""
  check "$block" "only error pages"                "html"         1 "" ""
done

echo "== $pass passed, $fail failed"
[ "$fail" -eq 0 ]
