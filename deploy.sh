#!/bin/bash
set -e

if [ ! -f ansible/vars.yml ]; then
  echo "Error: ansible/vars.yml not found. Please create it using ansible/vars.yml.example as a template."
  exit 1
fi

echo "🚀 Starting Deployment..."
cd ansible
ansible-playbook site.yml
echo "✅ Deployment complete!"
