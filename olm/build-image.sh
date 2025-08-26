#!/usr/bin/env bash
{{{$version := printf "%s.%s.%s" .major .minor .patch }}}
mkdir -p bin
name="kube-state-metrics"
version="{{{$version}}}"
registry="container-registry.oracle.com/olcne"
docker_tag=${registry}/${name}:v${version}
ldflags="
      -s
      -w
      -X main.version=v%{version}
      -X github.com/prometheus/common/version.Version=${version}
      -X github.com/prometheus/common/version.Revision=${GIT_REVISION}
      -X github.com/prometheus/common/version.Branch=${BRANCH}
      -X github.com/prometheus/common/version.BuildUser=${USER}@${HOST}
      -X github.com/prometheus/common/version.BuildDate=${BUILD_DATE}"

docker build --pull \
    --build-arg https_proxy=${https_proxy} \
    -t ${docker_tag} -f ./olm/builds/Dockerfile .
docker save -o ${name}.tar ${docker_tag}
