### Installation

Please note the prerequisite is to have docker daemon installed with the docker group ID set to `999`.

Example docker provider configuration:

```hcl
provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address     = "https://index.docker.io/v1/"
    config_file = pathexpand("~/.docker/config.json")
  }

}
```

Reference and configure the module:

```hcl
module "pycharm" {
  source = "git@github.com:overratedcorp/pycharm.git?ref=1.0.0"


}
```

### Development

Install homebrew deps:

```bash
brew bundle
```

Enable direnv configurations:

```bash
direnv allow
```

Install and activate terraform:

```bash
tfenv install min-required
tfenv use min-required
```
