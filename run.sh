#!/usr/bin/env bash
# run.sh — build and run the batch edge-detection pipeline end to end,
# then capture proof-of-execution artifacts into proof_of_execution/.
#
# Usage: ./run.sh

set -euo pipefail

echo "=== 1. (Re)generating sample input data ==="
if [ ! -d "data/input" ] || [ -z "$(ls -A data/input 2>/dev/null)" ]; then
  python3 scripts/generate_sample_data.py
else
  echo "data/input already populated ($(ls data/input | wc -l) files), skipping."
fi

echo ""
echo "=== 2. Building project (make) ==="
make clean
make

echo ""
echo "=== 3. Running edge_detect on the full batch ==="
mkdir -p proof_of_execution
LOGFILE="proof_of_execution/run_log_$(date +%Y%m%d_%H%M%S).txt"

./bin/edge_detect --input data/input --output data/output --threshold 60 --verbose | tee "$LOGFILE"

echo ""
echo "Run complete. Log saved to: $LOGFILE"
echo "Processed images written to: data/output/"
echo ""
echo "Remember to commit data/output/ and proof_of_execution/ so the log"
echo "and sample outputs are visible in the repository for grading."
