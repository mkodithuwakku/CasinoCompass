#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
verification_dir=$(mktemp -d "${TMPDIR:-/tmp}/casinocompass-verification.XXXXXX")
trap 'rm -rf "$verification_dir"' EXIT
simulator_id="${1:-booted}"
architecture=$(uname -m)
sdk_path=$(xcrun --sdk iphonesimulator --show-sdk-path)
SDKROOT="$sdk_path" xcrun --sdk iphonesimulator swiftc -parse-as-library -sdk "$sdk_path" -target "$architecture-apple-ios17.0-simulator" \
  CasinoCompass/Models/CasinoData.swift \
  CasinoCompass/Models/CasinoVenue.swift \
  CasinoCompass/Models/CompassMath.swift \
  CasinoCompass/Services/LocationService.swift \
  CasinoCompass/Views/ShareCardView.swift \
  tools/verify_release.swift -o "$verification_dir/verify"
xcrun simctl spawn "$simulator_id" "$verification_dir/verify"
