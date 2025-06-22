#!/bin/bash

# Succinct Prover - Default SSH Key Setup! Created by Rex ⚡

echo "------------------------------------"
echo "Succinct Prover SSH Setup Script"
echo "Created by Rex ⚡"
echo "------------------------------------"


echo "🔐 Generating default SSH key....."

# Backup existing default key if it exists
if [ -f ~/.ssh/id_rsa ]; then
  echo "⚠️ Existing SSH key found. Backing it up..."
  mv ~/.ssh/id_rsa ~/.ssh/id_rsa.backup.$(date +%s)
  mv ~/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub.backup.$(date +%s)
fi

# Generate new default key (no passphrase)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Set correct permissions
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

echo ""
echo "✅ New default SSH key created and set."

echo "🔑 Your public key (copy this into Vast.ai or Hyperbolic):"
echo "----------------------------------------------------------"
cat ~/.ssh/id_rsa.pub
echo "----------------------------------------------------------"
