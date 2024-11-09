# registry

This subfolder contains templates and values files needed to render configuration for a lab-wide container registry.

The registry currently uses [mcronce/oci-registry](https://github.com/mcronce/oci-registry) with some minor nginx path rewriting to be compatible with both Podman and Containerd. Bootstrapping and deployment is done to a Raspberry Pi 4 (4gb) running Fedora CoreOS and rootless Podman via [coreos-installer](https://coreos.github.io/coreos-installer/).

