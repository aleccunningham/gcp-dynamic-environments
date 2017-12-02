#!/bin/bash
set -e
# Create and destroy compute instances using a tagged root disk
gcloud auth activate-service-account --key-file /vagrant/creds/vm-manager.json
# TODO
