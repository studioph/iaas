# flatcar
Templates for rendering Flatcar [Container Linux Configs](https://www.flatcar.org/docs/latest/provisioning/cl-config/) to be used with iPXE booting Flatcar with [Matchbox](https://matchbox.psdn.io/).

Since Matchbox does not have extensive capabilities when it comes to templating, [Gomplate](https://docs.gomplate.ca/) is used to template the yaml config, which is then piped to the [Config Transpiler](https://www.flatcar.org/docs/latest/provisioning/config-transpiler/) to generate the ignition config.

The overall goal is to be able to have a declarative, versioned configuration for my bare-metal homelab servers much in the same way that my current [compose](https://github.com/paulhutchings/compose) repo holds my `docker-compose` files (which are then deployed with [Portainer](https://www.portainer.io/)). As I migrate to a GitOps-based workflow for my homelab, I will also be exploring and applying these same methods to the configurations used by other options like [Talos](https://talos.dev/).
