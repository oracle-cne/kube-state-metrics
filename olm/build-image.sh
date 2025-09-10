#!/usr/bin/env bash
{{{$version := printf "%s.%s.%s" .major .minor .patch }}}
mkdir -p bin
name="kube-state-metrics"
version="{{{$version}}}"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}

patch < olm/Makefile.patch

docker build --pull \
    --build-arg https_proxy=${https_proxy} \
    -t ${docker_tag} -f ./olm/builds/Dockerfile .
docker save -o ${name}.tar ${docker_tag}
