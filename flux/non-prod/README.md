# Flux - non-prod

This is the flux setup for the non-prod cluster.

We use flux to synchronize the contents of this Git-repository to our Kyma clusters. Therefore we have one set of each flux component running in each of our clusters in the flux-system namespace. The setup for flux itself is also contained in this directory.

## Installation & Upgrade

Flux can be installed into the cluster and also upgraded by using the following shell scripts:
- **flux-install.sh:** This script uses [flux cli](https://fluxcd.io/flux/installation/#install-the-flux-cli) to create or update
    - the flux installation: [flux-install.yml](flux-install.yml)
    - our flux Git-repository definition: [flux-system-source.yml](flux-system-source.yml)
    - our flux-system kustomization definition [flux-system-kustomization.yml](flux-system-kustomization.yml)
- **apply.sh:** This script applies all resources of the basic flux setup contained in this directory to the test context of the kubernetes configuration. This should be only used to initially start/install flux into a new cluster, afterwards updating the resources in the Git-repository should be sufficient. 

In order to upgrade flux to a new version the most recent version of the flux cmdline client (see https://github.com/fluxcd/flux2/releases) should be installed and the flux-install.sh script has to be executed. This updates the flux-install.yml file which can then be committed to github so that flux then upgrades itself. 

Also the flux version (tag) has to be updated in [flux-monitoring.yml](flux-monitoring.yml).

## Usage

Flux synchronizes the contents of Git-repositories based on GitRepository and Kustomizations objects.

### GitRepository objects

Currently we only have one Git-repository containing our kubernetes manifests (this repository) for that we already have a GitRepository object (see https://fluxcd.io/flux/components/source/gitrepositories/) in our cluster: 
- [flux-system-source.yml](flux-system-source.yml)

Therefore this usually does not have to be changed. 

### Kustomization objects

In order to let flux synchronize our applications we use the integration of [kustomize](https://kustomize.io/) in flux. To have one of our application components deployed by flux it has to be in a subfolder of our Git-repository that a flux-kustomization object points to (see https://fluxcd.io/flux/components/kustomize/kustomization/).

The first kustomization objects are defined by/for flux itself:
- [flux-system-kustomization.yml](flux-system-kustomization.yml)

These kustomization objects point to (see path attribute) to their containing folder. Since there is no kustomization.yaml file in this directory this object tells flux to synchronize all yaml files in this or any subdirectories to the kyma-cluster (see https://fluxcd.io/flux/components/kustomize/kustomization/#generate-kustomizationyaml).

Additional kustomization objects are defined for our application components in namespace specific folders: 
- [dev](dev)

