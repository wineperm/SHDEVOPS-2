source "yandex" "yc-task3" {
  folder_id           = "!!!!!!!!!!!!!!!"
  source_image_family = "ubuntu-2004-lts"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
  image_description   = "05-virt-02-iaac"
  image_name          = "yc-task3"
  subnet_id           = "!!!!!!!!!!!!!!!"
  disk_type           = "network-hdd"
  zone                = "ru-central1-a"
  token               = "!!!!!!!!!!!!!!!"
}

build {
  sources = ["source.yandex.yc-task3"]

  provisioner "shell" {
    inline = [
      # Docker
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce containerd.io",
      "sudo usermod -aG docker $USER",
      "sudo chmod 666 /var/run/docker.sock",
      "sudo useradd -m -s /bin/bash -G docker yc-user",
      
      # Other packages
      "sudo apt-get install -y htop tmux",
      
      # Test - Check versions for installed components
      "echo '=== Tests Start ==='",
      "docker version",
      "htop -v",
      "tmux -V",
      "echo '=== Tests End ==='"
    ]
  }

}


