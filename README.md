# Succinct Stage 2.5 Setup

- Video Guide: 

It's advisable you use this guide alongside the video guide above, so as to get the use of each codeline.

---

## STEP I: Generate your SSH Key on your local machine

- Generate Key:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/[desired_keyname]
```

- List generated key:

```bash
ls ~/.ssh
```

- View public key of the SSH

```bash
cat ~/.ssh/[keyname]
```

---

## STEP II: Calibrate GPU

```bash
docker run --rm --gpus all --network host -v /var/run/docker.sock:/var/run/docker.sock public.ecr.aws/succinct-labs/spn-node:latest-gpu calibrate --usd-cost-per-hour 0.5 --utilization-rate 0.6 --profit-margin 0.2 --prove-price 1.0
```

---

## STEP III: Set Environment Element

```bash
export PGUS_PER_SECOND= [Value from calibration]
export PROVE_PER_BPGU= [Value from calibration]
export PROVER_ADDRESS= [Prover Address not Wallet Address]
export PRIVATE_KEY= [Private Key Wallet with staked $PROVE token]
```

### Faucet Links:

- Faucet Trade Bot (Drips 0.05 ETH): https://t.me/faucet_trade_bot

--- 

### STEP IV: Run Prover

```bash
docker run -d --name spn-prover \
  --gpus all \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart unless-stopped \
  -e PGUS_PER_SECOND=366755 \
  -e PROVE_PER_BPGU=0.76 \
  -e PRIVATE_KEY=your_private_key \
  -e PROVER_ADDRESS=0xYourProverAddress \
  public.ecr.aws/succinct-labs/spn-node:latest-gpu prove \
  --rpc-url https://rpc-production.succinct.xyz \
  --throughput $PGUS_PER_SECOND \
  --bid $PROVE_PER_BPGU \
  --private-key $PRIVATE_KEY \
  --prover $PROVER_ADDRESS
```

And voila, you have successfully started contributing to the Succinct Network as a Prover! 😁

## Necessary Commands

- Start again if it ever stops:

```bash
docker start spn-prover
```

- Stop Manually:

```bash
docker stop spn-prover
```

- Check the logs:

```bash
docker logs -f spn-prover
```


