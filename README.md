## GCP CI Architecture

### Flow

- Push to github, which triggers a build via Google's container builder (120min free build time/day) along with the creation of a f1-micro compute instance
- VM is provisioned as it is booted up with docker and docker-compose with the help of Vagrant provisioning
- The repository is cloned locally to the machine
- When a new image is built, the `$IMAGE_TAG` variable is updated with the new tag (`$SHORT_SHA`, aka leading seven characters of the commit checksum) and docker-compose will restart the application using the newer image
- Using the predefined docker network and data container, `docker-compose up` does the rest of the heavy lifting
- At the end of each work day, all resources are destroyed, with the exception of the root disks for compute instances that were running at the time of execution. In the morning, the prior VM's are rebooted with their root disk.

Huzzah!

Notes:

- This repository assumes you already have a copy of the `$IMAGE:latest`, tagged for GCP (which looks like this `us.gcr.io/$PROJECT_ID/$IMAGE:$IMAGE_TAG`), image on your machine. Clone the analyte repository and build `analyte` and `analyte_base` if you have not already.
- This makes use of two service accounts -- one for VM creation, and another that is used on the VM itself that has registry permissions to access images on GCP. It is not enabled by default, but can be set on the VM via:

```Bash
$ cd /vagrant
$ gcloud auth activate-service-account --key-file creds/registry-access.json
```

You can now pull images and interact with the Google Cloud project. Checking the registry is a great way to see your commit history and run specific versions of your branch using:

```Bash
$ gcloud container images list
```
### Access

```Bash
$ gcloud compute --project "$PROJECT_ID" ssh --zone "$COMPUTE_ZONE" "$VM_NAME"
```

This will only work if you have configured your Google generated SSH keys to work with compute instances tied to the `$PROJECT_ID`!

### Runtime/Build/Environment Variables

- `$COMPOSE_PROJECT_NAME`
- `$IMAGE`, `$IMAGE_TAG`, `$SHORT_SHA`
- `$IMAGE_APP_1`, `$IMAGE_APP_2`, `$IMAGE_APP_3`
- `$DB_NAME`

### Building

Google's managed building service, [Container Builder](https://cloud.google.com/container-builder/) can build images when triggered, with the first 120min build time per day free.

```Bash
$ gcloud container builds submit . --config=build-steps.yaml
```

Runtime substitutions:

- `$PROJECT_ID`: build.ProjectId
- `$BUILD_ID`: build.BuildId
- `$REPO_NAME`: build.Source.RepoSource.RepoName
- `$BRANCH_NAME`: build.Source.RepoSource.Revision.BranchName
- `$TAG_NAME`: build.Source.RepoSource.Revision.TagName
- `$REVISION_ID`: build.SourceProvenance.ResolvedRepoSource.Revision.CommitSha
- `$COMMIT_SHA`: build.SourceProvenance.ResolvedRepoSource.Revision.CommitSha
- `$SHORT_SHA` : The first seven characters of COMMIT_SHA


### Database

During the initial `docker-compose up`, the `mysql` container will be bootstrapped with a test database for local development use -- this will create a clean copy and make it accessible via the `db-data` docker volume container. If you have access to this container externally, just make sure it's mounted and you should be good to go.

### External docker objects

Both the network and data container are created during the initial provisioning of the VM, which you can confirm via `docker volume list` and `docker network list`.

### Vagrant

The real magic happens in the Vagrantfile. Running `vagrant up` and you'll be presented with a GCP compute instance bootstrapped with docker and docker-compose! You can access it via `vagrant ssh` when needed, as GCP keeps a copy of your SSH keys and applies them project-wide to all instances. The abstraction Vagrant provides allows you to handle the machine as if it were a Virtualbox instance.

The only caveat when using the Vagrantfile is in regards to SSH keys; you will have to specify the path to the keys that Google provided under `~/.ssh/google_compute_engine` (or something similar). You can easily do this via the variable definitions at the top of the file, and if your VM was created via Jenkins it should already be taken care of.

Custom user SSH keys might take some modifying; it is recommended to use `google_compute_engine.pub` as it still identifies the user and is formatted to work with compute instances.

## Hashicorp integrations

### Terraform

### Packer

### Ansible

### Vault
