#!/bin/bash
echo "=====>docker container start<====="
docker start c11d22302729 b6a2dd7470d0 31d5207907e2

echo "=====>ansible-playbook run<====="
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file pass.txt

echo "=====>docker container stop<====="
docker stop c11d22302729 b6a2dd7470d0 31d5207907e2