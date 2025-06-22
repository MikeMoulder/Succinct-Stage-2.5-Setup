#!/bin/bash

echo "------------------------------------------"
echo "Succinct Prover GPU Setup & Prover Runner"
echo "Created by Rex ⚡"
echo "------------------------------------------"

echo "🧱 Installing Docker (if not present)..."
sudo apt update && sudo apt install -y docker.io

echo "⚡ Calibrating GPU..."
docker run --rm --gpus all --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  public.ecr.aws/succinct-labs/spn-node:latest-gpu calibrate \
  --usd-cost-per-hour 0.5 \
  --utilization-rate 0.6 \
  --profit-margin 0.2 \
  --prove-price 1.0 | tee calibration_output.txt

# Parse calibration values
PGUS=$(grep -oP '(?<=PGUS_PER_SECOND=)[0-9.]+' calibration_output.txt)
BPGU=$(grep -oP '(?<=PROVE_PER_BPGU=)[0-9.]+' calibration_output.txt)

echo ""
echo "✅ Calibration Complete."
echo "PGUS_PER_SECOND = $PGUS"
echo "PROVE_PER_BPGU  = $BPGU"
echo ""

read -p "Enter your PROVER_ADDRESS: " PROVER_ADDRESS
read -p "Enter your PRIVATE_KEY: " PRIVATE_KEY

echo "🚀 Launching SPN Prover as Docker container..."

docker run -d --name spn-prover \
  --gpus all \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  -e PGUS_PER_SECOND=$PGUS \
  -e PROVE_PER_BPGU=$BPGU \
  -e PRIVATE_KEY=$PRIVATE_KEY \
  -e PROVER_ADDRESS=$PROVER_ADDRESS \
  public.ecr.aws/succinct-labs/spn-node:latest-gpu prove \
  --rpc-url https://rpc-production.succinct.xyz \
  --throughput $PGUS \
  --bid $BPGU \
  --private-key $PRIVATE_KEY \
  --prover $PROVER_ADDRESS

echo ""
echo "✅ Prover is running in the background!"
echo "Use this to monitor:"
echo "  docker logs -f spn-prover"
