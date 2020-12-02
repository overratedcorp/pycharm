locals {
  bind_mounts = {
    "/etc/hostname" = {
      flags = "ro"
    },
    pathexpand("~/.docker") = {
      target = "/home/pycharm/.docker",
    }
    pathexpand("~/PycharmProjects") = {
      target = "/home/pycharm/PycharmProjects"
    }
    "/tmp/.X11-unix" = {
      flags = "ro"
    }
    "/var/run/docker.sock" = {}
  }
  environment = concat([
    "DISPLAY=${data.external.env.result.DISPLAY}",
    "GIT_EMAIL=${data.external.git_config.result.gitemail}",
    "GIT_USER=${data.external.git_config.result.gituser}",
    "HOSTNAME=${local.hostname}",
    "TF_PLUGIN_CACHE_DIR=/home/pycharm/.terraform.d/plugin-cache",
    "USER=pycharm",
    "XAUTHORITY=${data.external.env.result.XAUTHORITY}",
  ], var.env_vars)
  hostname = trimspace(data.local_file.hostname.content)
  local_volumes = {
    cache     = ".cache",
    config    = ".config",
    java      = ".java",
    local     = ".local",
    terraform = ".terraform.d",
    ssh       = ".ssh",
  }
  registry_url = "rezultat/pycharm:1.0.0"
}
