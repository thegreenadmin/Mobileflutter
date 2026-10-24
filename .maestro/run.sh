#!/usr/bin/env bash
# Runs Maestro flows against the app on the currently booted iOS simulator / connected Android device.
#
# Usage:
#   .maestro/run.sh                          # run all flows
#   .maestro/run.sh flows/store_search_tabs.yaml  # run a single flow
#   .maestro/run.sh tests/full_smoke_suite.yaml   # run the full smoke suite
#   .maestro/run.sh suite stores             # run store_browsing_suite
#   .maestro/run.sh suite orders             # run order_flow_suite
#   .maestro/run.sh suite wallet             # run wallet_payment_suite
#   .maestro/run.sh suite smoke              # run full_smoke_suite
#   .maestro/run.sh suite all                # run all suites sequentially
set -euo pipefail

export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"

MAESTRO_DIR="$(cd "$(dirname "$0")" && pwd)"

run_test() {
  echo "==> Running: $1"
  maestro test "$1"
  echo ""
}

if [[ "${1:-}" == "suite" ]]; then
  case "${2:-all}" in
    stores)  run_test "$MAESTRO_DIR/tests/store_browsing_suite.yaml" ;;
    orders)  run_test "$MAESTRO_DIR/tests/order_flow_suite.yaml" ;;
    wallet)  run_test "$MAESTRO_DIR/tests/wallet_payment_suite.yaml" ;;
    smoke)   run_test "$MAESTRO_DIR/tests/full_smoke_suite.yaml" ;;
    cards)   run_test "$MAESTRO_DIR/tests/card_valid_scenario.yaml"
             run_test "$MAESTRO_DIR/tests/card_invalid_stripe.yaml" ;;
    all)
      run_test "$MAESTRO_DIR/tests/full_smoke_suite.yaml"
      run_test "$MAESTRO_DIR/tests/store_browsing_suite.yaml"
      run_test "$MAESTRO_DIR/tests/order_flow_suite.yaml"
      run_test "$MAESTRO_DIR/tests/wallet_payment_suite.yaml"
      run_test "$MAESTRO_DIR/tests/card_valid_scenario.yaml"
      run_test "$MAESTRO_DIR/tests/card_invalid_stripe.yaml"
      ;;
    *) echo "Unknown suite: $2"; echo "Available: stores, orders, wallet, smoke, cards, all"; exit 1 ;;
  esac
else
  TARGET="${1:-$MAESTRO_DIR/flows}"
  run_test "$TARGET"
fi
