#!/usr/bin/env bash

mkdir -p bin
name="kube-state-metrics"
version="2.16.0"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}

patch < olm/Makefile.patch

docker build --pull \
    --build-arg https_proxy=${https_proxy} \
    -t ${docker_tag} -f ./olm/builds/Dockerfile .
docker save -o ${name}.tar ${docker_tag}
