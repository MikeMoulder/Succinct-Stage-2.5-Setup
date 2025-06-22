#!/bin/bash

echo "------------------------------------------"
echo "Succinct Prover GPU Setup & Prover Runner"
echo "Created by Rex ⚡"
echo "------------------------------------------"

# Auto-install Docker if missing
if ! command -v docker &> /dev/null; then
    echo "🔧 Docker not found. Installing Docker..."
    
    sudo apt remove -y containerd || true
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "✅ Docker installed successfully."
fi

# Check if required environment variables are set
if [[ -z "$PROVER_ADDRESS" || -z "$PRIVATE_KEY" ]]; then
    echo "❌ ERROR: Please export PROVER_ADDRESS and PRIVATE_KEY before running this script."
    echo "Example:"
    echo "  export PROVER_ADDRESS=0xYourProverAddress"
    echo "  export PRIVATE_KEY=yourPrivateKey"
    exit 1
fi

echo "⚡ Calibrating GPU..."
CALIBRATION_OUTPUT=$(docker run --rm --gpus all --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  public.ecr.aws/succinct-labs/spn-node:latest-gpu calibrate \
  --usd-cost-per-hour 0.5 \
  --utilization-rate 0.6 \
  --profit-margin 0.2 \
  --prove-price 1.0)

echo "$CALIBRATION_OUTPUT" | tee calibration_output.txt

PGUS=$(echo "$CALIBRATION_OUTPUT" | awk -F'│' '/Estimated Throughput/ {gsub(/[^0-9]/,"",$3); print $3}')
BPGU=$(echo "$CALIBRATION_OUTPUT" | awk -F'│' '/Estimated Bid Price/ {gsub(/[^0-9.]/,"",$3); print $3}')

if [[ -z "$PGUS" || -z "$BPGU" ]]; then
  echo "❌ Failed to extract calibration values. Please check calibration_output.txt manually."
  exit 1
fi

echo ""
echo "✅ Calibration Complete."
echo "PGUS_PER_SECOND = $PGUS"
echo "PROVE_PER_BPGU  = $BPGU"
echo ""

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
