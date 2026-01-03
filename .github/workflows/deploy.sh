#!/bin/bash

# This script deploys a new container from Github
# upon a merge to main in https://github.com/kaitlyn-squyres/ignatianart.
# We do this all in a single script rather than inline in the
# github action itself so that we can use ssh authorized-keys
# controls to only allow the ssh key used to run this one,
# single command.
#
# See
# https://github.com/kaitlyn-squyres/ignatianart/blob/main/.github/workflows/docker-publish.yml
# for how this is invoked.
#
# Per below, this file should be installed at:
#
# /var/www/squyres.com/kaitlyn/deploy.sh
#
# Ensure that it is executable.
#
# In the appropriate user, the .ssh/authorized_keys file the deploy
# key line should look like this:
#
# command="/var/www/squyres.com/kaitlyn/deploy.sh",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-... KEY

#----------------------------------------

set -euxo pipefail

echo Deploying ignatianart.kaitlyn.squyres.com

# The original SSH command launched from the github action had 3 CLI
# parameters that we need.
set $SSH_ORIGINAL_COMMAND
shift

token=$1
actor=$2
repo=$3

# Log in to GitHub Container Registry
echo "$token" | docker login ghcr.io -u "$actor" --password-stdin

# Pull the latest image
docker pull "ghcr.io/$repo:latest"

# Stop and remove the old container if it exists
docker stop ignatianart || true
docker rm ignatianart || true

# Launch new container with bind-mounted logs
docker run -d \
       --name ignatianart \
       --restart unless-stopped \
       -p 5001:80 \
       "ghcr.io/$repo:latest"

# Logout from registry
docker logout ghcr.io
