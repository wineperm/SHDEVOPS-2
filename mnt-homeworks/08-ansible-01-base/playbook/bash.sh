#!/bin/bash
echo "=====>docker container start<====="
docker start ubuntu centos7 fedora

echo "=====>ansible-playbook run<====="
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file pass.txt

echo "=====>docker container stop<====="
docker stop ubuntu centos7 fedora