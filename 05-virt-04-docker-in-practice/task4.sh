#!/bin/bash

cd /opt
sudo git clone https://github.com/wineperm/shvirtd-example-python.git
cd /opt/shvirtd-example-python
sudo docker compose up -d
