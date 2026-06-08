#!/bin/bash
#
# Download patches from radxa-pkg/aic8800 debian/patches
# Run this script from the repository root directory.
#

set -e

RADXA_RAW="https://raw.githubusercontent.com/radxa-pkg/aic8800/main/debian/patches"
PATCH_DIR="aic8800-sdio/patches"

declare -A PATCHES=(
  ["fix-sdio-firmware-path.patch"]="010-fix-sdio-firmware-path.patch"
  ["fix-sdio-fall-through.patch"]="020-fix-sdio-fall-through.patch"
  ["fix-debug-file-with-no-debug-symbols.patch"]="030-fix-debug-file-with-no-debug-symbols.patch"
  ["fix-linux-6.1-build.patch"]="040-fix-linux-6.1-build.patch"
  ["fix-linux-6.5-build.patch"]="050-fix-linux-6.5-build.patch"
  ["fix-linux-6.7-build.patch"]="060-fix-linux-6.7-build.patch"
  ["fix-linux-6.9-build.patch"]="070-fix-linux-6.9-build.patch"
  ["fix-linux-6.13-build.patch"]="080-fix-linux-6.13-build.patch"
  ["fix-linux-6.14-build.patch"]="090-fix-linux-6.14-build.patch"
  ["fix-linux-6.15-build.patch"]="100-fix-linux-6.15-build.patch"
  ["fix-linux-6.16-build.patch"]="110-fix-linux-6.16-build.patch"
  ["fix-linux-6.17-build.patch"]="120-fix-linux-6.17-build.patch"
  ["fix-linux-6.19-build.patch"]="130-fix-linux-6.19-build.patch"
  ["fix-vmalloc-not-include.patch"]="140-fix-vmalloc-not-include.patch"
  ["fix-Lower-the-debugging-log-level.patch"]="150-fix-Lower-the-debugging-log-level.patch"
)

echo "Downloading patches from radxa-pkg/aic8800..."
echo ""

for src in "${!PATCHES[@]}"; do
  dst="${PATCHES[$src]}"
  echo "  $src -> $PATCH_DIR/$dst"
  curl -sL "$RADXA_RAW/$src" -o "$PATCH_DIR/$dst"
done

echo ""
echo "Done. Downloaded ${#PATCHES[@]} patches."
echo ""
echo "Note: These patches are from the radxa-pkg/aic8800 repository and are"
echo "licensed under GPL-2.0. See patches/README.md for details."
