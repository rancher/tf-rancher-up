#!/usr/bin/env bash
#
# Guards against rancher2 provider constraint drift.
#
# The rancher2 provider is branched per Rancher minor release, so a provider
# major is only valid for the Rancher minor it targets. RKE1 provisioning was
# dropped in Rancher 2.12, so the RKE1 modules and recipes are frozen at the
# last RKE1-compatible provider line, while everything else tracks the current
# release.
#
# Classes:
#   supported  ~> 15.<minor>       current Rancher line
#   rke1       ~> 8.5.0            last release with the full RKE1 resource set
#   shared     >= 8.5              child module used by both generations
#
# The supported constraint is resolved as a shape rather than a fixed string so
# that Renovate can move the minor within the line. Only a new provider major
# raises a PR, and that PR fails here until SUPPORTED_RANCHER2_MAJOR is bumped
# deliberately, confirming the branch now targets that Rancher minor.
#
# Any path declaring rancher2 that is not listed below is an error, so new
# modules and recipes have to be classified deliberately.

set -euo pipefail

SUPPORTED_RANCHER2_MAJOR="15"
SUPPORTED_PATTERN="^~> ${SUPPORTED_RANCHER2_MAJOR}\.[0-9]+$"
SUPPORTED_EXAMPLE="~> ${SUPPORTED_RANCHER2_MAJOR}.1"

RKE1_CONSTRAINT="~> 8.5.0"
SHARED_CONSTRAINT=">= 8.5"

SUPPORTED_PATHS="
modules/downstream/aws/EKS/
modules/downstream/aws/v2/
modules/downstream/custom/
modules/downstream/gcp/GKE/
modules/downstream/imported/
recipes/downstream/aws/EKS/
recipes/downstream/aws/v2/
recipes/downstream/custom/
recipes/downstream/gcp/GKE/
recipes/downstream/imported/
"

RKE1_PATHS="
modules/downstream/aws/rke/
recipes/downstream/aws/rke/
recipes/upstream/aws/rke/
recipes/upstream/azure/rke/
recipes/upstream/digitalocean/rke/
recipes/upstream/google-cloud/rke/
recipes/upstream/vmware/rke/
"

SHARED_PATHS="
modules/rancher/
"

in_paths() {
  local file="$1" path
  for path in $2; do
    [[ "$file" == "$path"* ]] && return 0
  done
  return 1
}

# Print every rancher2 required_providers version constraint in a file, or
# "<missing>" for a block without one.
extract_constraints() {
  perl -0777 -ne '
    while (/\brancher2\s*=\s*\{(.*?)\}/gs) {
      my $block = $1;
      if ($block =~ /\bversion\s*=\s*"([^"]+)"/) {
        print "$1\n";
      } else {
        print "<missing>\n";
      }
    }
  ' "$1"
}

failures=0
supported_values=""

while IFS= read -r file; do
  grep -q 'source *= *"rancher/rancher2"' "$file" || continue

  if in_paths "$file" "$SUPPORTED_PATHS"; then
    class="supported"
  elif in_paths "$file" "$RKE1_PATHS"; then
    class="rke1"
    expected="$RKE1_CONSTRAINT"
  elif in_paths "$file" "$SHARED_PATHS"; then
    class="shared"
    expected="$SHARED_CONSTRAINT"
  else
    echo "ERROR $file: declares rancher/rancher2 but the path has no version class."
    echo "       Add it to SUPPORTED_PATHS, RKE1_PATHS or SHARED_PATHS in $0."
    failures=$((failures + 1))
    continue
  fi

  while IFS= read -r actual; do
    case "$class" in
      supported)
        if [[ "$actual" == "<missing>" ]]; then
          echo "ERROR $file: rancher2 block has no version constraint (expected '$SUPPORTED_EXAMPLE' for $class)."
          failures=$((failures + 1))
        elif [[ ! "$actual" =~ $SUPPORTED_PATTERN ]]; then
          echo "ERROR $file: rancher2 version is '$actual', expected the supported line '$SUPPORTED_EXAMPLE' for $class."
          failures=$((failures + 1))
        else
          supported_values="$supported_values
$actual"
        fi
        ;;
      *)
        if [[ "$actual" == "<missing>" ]]; then
          echo "ERROR $file: rancher2 block has no version constraint (expected '$expected' for $class)."
          failures=$((failures + 1))
        elif [[ "$actual" != "$expected" ]]; then
          echo "ERROR $file: rancher2 version is '$actual', expected '$expected' for $class."
          failures=$((failures + 1))
        fi
        ;;
    esac
  done < <(extract_constraints "$file")
done < <(git ls-files '*.tf')

# Every supported path must agree on one minor, so a Renovate update lands
# everywhere or not at all.
distinct_supported=$(printf '%s\n' "$supported_values" | sed '/^$/d' | sort -u)
distinct_count=$(printf '%s\n' "$supported_values" | sed '/^$/d' | sort -u | wc -l | tr -d ' ')
if (( distinct_count > 1 )); then
  echo "ERROR supported rancher2 constraints are not consistent across paths:"
  printf '%s\n' "$distinct_supported" | sed 's/^/       /'
  failures=$((failures + 1))
fi

if (( failures > 0 )); then
  echo
  echo "$failures rancher2 constraint error(s) found."
  exit 1
fi

echo "All rancher2 provider constraints match their class (supported: ${distinct_supported:-none})."
