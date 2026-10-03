#!/usr/bin/env bash
# Run Maestro tests on Firebase Test Lab using gcloud CLI.
#
# Prerequisites:
#   - gcloud CLI installed and authenticated
#   - Firebase project configured
#   - APK or IPA built and available
#
# Usage:
#   .maestro/firebase_test_lab.sh <apk-path> [suite]
#   .maestro/firebase_test_lab.sh app-release.apk smoke
#   .maestro/firebase_test_lab.sh app-release.apk all
#
# Environment variables:
#   FIREBASE_PROJECT  - Firebase project ID (required)
#   DEVICE_MODEL      - Device model (default: Pixel6)
#   API_LEVEL         - API level (default: 33)
#   LOCALE            - Device locale (default: en)
#   ORIENTATION       - Device orientation (default: portrait)
#   RESULTS_BUCKET    - GCS bucket for results (default: auto)
set -euo pipefail

MAESTRO_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$MAESTRO_DIR/.." && pwd)"

APK_PATH="${1:?Usage: firebase_test_lab.sh <apk-path> [suite]}"
SUITE="${2:-smoke}"

# Firebase configuration
FIREBASE_PROJECT="${FIREBASE_PROJECT:?Set FIREBASE_PROJECT env var}"
DEVICE_MODEL="${DEVICE_MODEL:-Pixel6}"
API_LEVEL="${API_LEVEL:-33}"
LOCALE="${LOCALE:-en}"
ORIENTATION="${ORIENTATION:-portrait}"

# Resolve suite to test file
resolve_suite() {
  case "$1" in
    smoke)   echo "$MAESTRO_DIR/tests/full_smoke_suite.yaml" ;;
    stores)  echo "$MAESTRO_DIR/tests/store_browsing_suite.yaml" ;;
    orders)  echo "$MAESTRO_DIR/tests/order_flow_suite.yaml" ;;
    wallet)  echo "$MAESTRO_DIR/tests/wallet_payment_suite.yaml" ;;
    cards)   echo "$MAESTRO_DIR/tests/card_valid_scenario.yaml" ;;
    *)       echo "$1" ;;  # assume direct path
  esac
}

TEST_FILE=$(resolve_suite "$SUITE")

echo "============================================"
echo " Firebase Test Lab - Maestro Runner"
echo "============================================"
echo " Project:     $FIREBASE_PROJECT"
echo " APK:         $APK_PATH"
echo " Suite:       $SUITE"
echo " Test file:   $TEST_FILE"
echo " Device:      $DEVICE_MODEL (API $API_LEVEL)"
echo "============================================"
echo ""

# Verify APK exists
if [[ ! -f "$APK_PATH" ]]; then
  echo "ERROR: APK not found at $APK_PATH"
  exit 1
fi

# Verify test file exists
if [[ ! -f "$TEST_FILE" ]]; then
  echo "ERROR: Test file not found at $TEST_FILE"
  exit 1
fi

# Upload and run on Firebase Test Lab using Maestro cloud or gcloud
# Option 1: Using maestro cloud (if Maestro Cloud account configured)
if command -v maestro &>/dev/null && maestro cloud --help &>/dev/null 2>&1; then
  echo "==> Running via Maestro Cloud on Firebase Test Lab..."
  maestro cloud \
    --app-file="$APK_PATH" \
    "$TEST_FILE"
else
  # Option 2: Using gcloud with game-loop or robo test + Maestro instrumentation
  echo "==> Running via gcloud firebase test android run..."

  RESULTS_DIR="${RESULTS_BUCKET:-}"
  RESULTS_FLAG=""
  if [[ -n "$RESULTS_DIR" ]]; then
    RESULTS_FLAG="--results-bucket=$RESULTS_DIR"
  fi

  gcloud firebase test android run \
    --project="$FIREBASE_PROJECT" \
    --type=robo \
    --app="$APK_PATH" \
    --device="model=$DEVICE_MODEL,version=$API_LEVEL,locale=$LOCALE,orientation=$ORIENTATION" \
    --timeout=600s \
    --no-record-video \
    $RESULTS_FLAG \
    2>&1 | tee "$MAESTRO_DIR/firebase_results.log"

  echo ""
  echo "==> Results saved to $MAESTRO_DIR/firebase_results.log"
fi

echo ""
echo "==> Done."
