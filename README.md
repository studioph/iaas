# Homelab IaaS

This repo holds templates and configurations for the bare-metal servers in my homelab. Currently I'm using Fedora CoreOS booted via iPXE.

[Gomplate](https://docs.gomplate.ca/) is used to template the Butane yaml config, which is then piped to Butane to generate the ignition config.

The overall goal is to be able to have a declarative, versioned configuration for my bare-metal servers much in the same way that my current [compose](https://github.com/studioph/compose) repo holds my `docker-compose` files (deployed with [Portainer](https://www.portainer.io/)). I will also be exploring other options such as Talos when I migrate to Kubernetes.

When booting, the embedded iPXE script points to an nginx proxy that rewrites the URLs to point to the actual repository where the configuration is hosted (in this case here). This is to allow flexibility to change where the configuration is hosted without having to recompile a new iPXE image
