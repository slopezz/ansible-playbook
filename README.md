# Ansible Playbook Docker image

## ansible-playbook
Executes ansible-playbook command with an specific ansible version, so you can guarantee that anybody using an specific version will have the same result.

It can be integrated into a CI/CD pipeline with all dependancies resolved.

In addition, it has pip openshift package included, so it is possible to run ansible `k8s` module to run ansible playbooks with kubernetes or openshift clusters as targets.

```bash
docker run --rm -it -v $(pwd):/ansible/playbooks slopezz/ansible-playbook site.yml
```

You can add any possible ansible-playbook variable at the end of the execution, example:

```bash
docker run --rm -it -v $(pwd):/ansible/playbooks slopezz/ansible-playbook -i inventory site.yml --tags any-role -CD --vault-password-file vault.secret
```

## ansible-vault

If you want to run ansible-vault you can do it by changing the entrypoint:
```bash
docker run --rm -it -v $(pwd):/ansible/playbooks --entrypoint ansible-vault slopezz/ansible-playbook edit host_vars/host_example/vault.yml --vault-password-file vault.secret
```

## Makefile

With Makefile you can easily run some specific targets:
```bash
$ make help
build                          Build ansible-playbook image
run                            Run ansible-playbook image
run-vault                      Run ansible-vault with ansible-playbook image
tag-latest                     Tag ansible-playbook image as latest
push                           Push ansible-playbook image
help                           Print this help
```

## Images

Docker images will be available with specific ansible versions on [docker Hub](https://hub.docker.com/r/slopezz/ansible-playbook/tags/)
