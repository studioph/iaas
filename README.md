# Homelab IaaS

This repo holds templates and configurations for the bare-metal servers in my homelab. Currently I'm using Fedora CoreOS booted via iPXE.

[Gomplate](https://docs.gomplate.ca/) is used to template the Butane yaml config, which is then piped to Butane to generate the ignition config.

The overall goal is to be able to have a declarative, versioned configuration for my bare-metal servers much in the same way that my current [compose](https://github.com/paulhutchings/compose) repo holds my `docker-compose` files (deployed with [Portainer](https://www.portainer.io/)). I will also be exploring other options such as Talos when I migrate to Kubernetes.

The servers are bootstrapped via an Nginx server running on a raspberry pi, which is itself bootstrapped via [`coreos-installer`](https://coreos.github.io/coreos-installer/) when writing to the SD card. Nginx can point clients to an external hosted git (such as GitHub) or serve the static files locally as well. The pi also periodically pulls the latest coreos PXE images, and the servers reboot on a predefined schedule to stay up to date.
