# Succinct Stage 2.5 Setup

### Video Guide

- Link: 

It's advisable you use this guide alongside the video guide above, so as to get the use of each codeline.

Start from STEP I if you are renting/rented a GPU from any marketplace else SKIP to STEP II if you are using the GPU on your local machine!

---

## STEP I: Rent GPU & Link SSH Key

### Create A Vast.ai Account First

- Link: https://cloud.vast.ai/?ref_id=62897&creator_id=62897&name=Ubuntu%20Desktop%20(VM)

### Generate your SSH Key on your local machine

- Generate Key:

```bash
curl -sL https://raw.githubusercontent.com/MikeMoulder/Succinct-Stage-2.5-Setup/main/ssh_setup.sh | bash
```
---

## STEP II: Setup Prover CLI & Activate Prover Node In 1-Click!

### Setup Credentials:
```bash
export PROVER_ADDRESS=[prover address not wallet address]
export PRIVATE_KEY=[wallet with staked $prove token]
```

### Setup Link:
```bash
curl -sL https://raw.githubusercontent.com/MikeMoulder/Succinct-Stage-2.5-Setup/main/gpu_prover_setup.sh | bash
```

### Faucet Links:

- Faucet Trade Bot (Drips 0.05 ETH): https://t.me/faucet_trade_bot

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


