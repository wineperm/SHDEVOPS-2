terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "ssh://qwerty@158.160.51.49:22" 
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

# Pulls the image
resource "docker_image" "mysql" {
  name = "mysql:8"
  keep_locally = false
}

# Create a container
resource "docker_container" "task2" {
  image = docker_image.mysql.image_id
  name  = "task2"
  env = ["MYSQL_DATABASE=wordpress", "MYSQL_USER=wordpress", "MYSQL_ROOT_HOST=%", "MYSQL_ROOT_PASSWORD=${random_password.random_string.result}", "MYSQL_PASSWORD=${random_password.random_string.result}"] 
}

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}
