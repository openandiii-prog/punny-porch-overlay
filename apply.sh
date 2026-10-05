#!/usr/bin/env bash
# Applies the Punny Porch design overlay to the store theme. Run it from the theme root
# (the folder that holds package.json and app/):
#   bash /tmp/porch/apply.sh canary     three new files only, to test the delivery channel
#   bash /tmp/porch/apply.sh            the full overlay
# It only writes the files listed in MANIFEST.sha256. It never deletes anything, and it stops
# before copying if the files it would replace are not the ones the overlay was built from.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f package.json ] || [ ! -d app ] || [ ! -d components ]; then
  echo "STOP: run this from the theme root (the folder with package.json and app/)."
  exit 1
fi

(cd "$here" && sha256sum -c --quiet SHA256SUMS) || { echo "STOP: the downloaded archives are damaged."; exit 1; }

if [ "${1:-}" = "canary" ]; then
  tar -xzf "$here/canary.tgz"
  sha256sum -c "$here/CANARY.sha256"
  echo "CANARY OK"
  exit 0
fi

if sha256sum -c --quiet "$here/MANIFEST.sha256" >/dev/null 2>&1; then
  echo "OVERLAY OK: already in place, nothing to do"
  exit 0
fi

if ! sha256sum -c --quiet "$here/PREIMAGE.sha256"; then
  echo "STOP: the theme has changed since the overlay was built. Nothing was copied."
  exit 1
fi

tar -xzf "$here/overlay.tgz"
sha256sum -c --quiet "$here/MANIFEST.sha256"
echo "OVERLAY OK: $(wc -l < "$here/MANIFEST.sha256") files in place"
