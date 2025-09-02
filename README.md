# Homelab IaaS

This repo holds templates and configurations for the bare-metal servers in my homelab. Currently I'm using Fedora CoreOS.

[Gomplate](https://docs.gomplate.ca/) is used to template the Butane yaml config, which is then piped to Butane to generate the ignition config.

The overall goal is to be able to have a declarative, versioned configuration for my bare-metal servers.
