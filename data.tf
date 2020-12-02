data "external" "env" {
  program = [
    "/usr/bin/jq", "-n", "env",
  ]
}

data "external" "git_config" {
  program = [
    "/bin/bash", "-c",
    "/usr/bin/jq -n --arg gitemail \"$(git config --get user.email)\" --arg gituser \"$(git config --get user.name)\" '{\"gitemail\": $gitemail, \"gituser\", $gituser}'",
  ]
}

data "local_file" "hostname" {
  filename = "/etc/hostname"
}
