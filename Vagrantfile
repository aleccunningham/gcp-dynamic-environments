# -*- mode: ruby -*-
# vi: set ft=ruby :
# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VAGRANTFILE_API_VERSION = "2"
# Project specific variables
$PROJECT_ID = ""
$SERVICE_ACCOUNT = ""
$CREDS_LOCATION = "creds/credentials.json"
$IMAGE_TAG = "latest"
$BRANCH_SLUG ?= "master"
# Custom SSH access
$SSH_USERNAME = ""
$SSH_KEY = "~/.ssh/google_compute_engine"
# Provision scripts
$PROVISION_UBUNTU = "scripts/provision.sh"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "google/gce"

  config.vm.provider :google do |google, override|
    google.google_project_id = $PROJECT_ID
    google.google_client_email = $SERVICE_ACCOUNT
    google.google_json_key_location = $CREDS_LOCATION

    override.ssh.username = $SSH_USERNAME
    override.ssh.private_key_path = $SSH_KEY
    #override.ssh.private_key_path = ~/.ssh/google_compute_engine

    google.zone = "us-central1-b"
    google.zone_config "us-central1-b" do |vm_zone|
      vm_zone.name = $BRANCH_SLUG
      vm_zone.image = "ubuntu-1604-xenial-v20171121a"
      vm_zone.machine_type = "f1-micro"
      #vm_zone.metadata = {'custom' => 'metadata', 'testing' => 'foobarbaz'}
      #vm_zone.scopes = ['https://www.googleapis.com/auth/compute']
      #vm_zone.tags = ['analyte']
    end
  end
  # Download analyte image tagged by case
  config.vm.provision "shell", path: $PROVISION_UBUNTU # , env: {"IMAGE_TAG" => $IMAGE_TAG}
  #machine.vm.provision "file", source: "creds/registry-access.json", destination: "~/creds/registry-access.json"
  #config.vm.provision "shell", path: "workspace.sh", env: {"IMAGE_TAG" => $IMAGE_TAG}
end
