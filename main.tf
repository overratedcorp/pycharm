data "docker_registry_image" "default" {
  name = local.registry_url
}

resource "docker_image" "default" {
  name = data.docker_registry_image.default.name

  pull_triggers = [
    data.docker_registry_image.default.sha256_digest
  ]
}

resource "docker_volume" "pycharm" {
  for_each = local.local_volumes
  name     = "pycharm_${each.key}"
}

resource "docker_container" "pycharm" {
  lifecycle {
    ignore_changes = [
      working_dir,
    ]
  }
  env         = local.environment
  group_add   = var.group_list
  image       = docker_image.default.latest
  memory      = var.container_mem_limit
  memory_swap = -1
  dynamic "mounts" {
    for_each = local.bind_mounts
    content {
      read_only = lookup(mounts.value, "flags", "") == "ro"
      source    = mounts.key
      target    = coalesce(lookup(mounts.value, "target", ""), mounts.key)
      type      = "bind"
    }
  }
  dynamic "mounts" {
    for_each = local.local_volumes
    content {
      source = docker_volume.pycharm[mounts.key].name
      target = "/home/pycharm/${mounts.value}"
      type   = "volume"
    }
  }
  must_run = false
  name     = "pycharm"
  dynamic "networks_advanced" {
    for_each = var.docker_networks

    content {
      name = networks_advanced.value
    }
  }
  start = true
  dynamic "upload" {
    for_each = var.upload_files
    content {
      content_base64 = base64encode(upload.value)
      file           = upload.key
    }
  }
}
