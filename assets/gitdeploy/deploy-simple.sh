#!/bin/bash

echo "updating"
echo "Switching to project docroot."
cd ./app
echo ""
echo "Pulling down latest code."
git pull --ff-only origin prod
git submodule update --init --recursive --remote
echo ""
echo "Deployment complete."
