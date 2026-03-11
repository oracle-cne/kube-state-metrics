FROM container-registry.oracle.com/os/oraclelinux:9 AS builder

RUN dnf config-manager --enable ol9_codeready_builder && \
    dnf -y install git make golang hostname && \
    go version

# Copy the contents of the repository
COPY . /workspace/go/src/github.com/oracle-cne/kube-state-metrics

ENV GOPATH=/workspace/go CGO_ENABLED=0
WORKDIR /workspace/go/src/github.com/oracle-cne/kube-state-metrics

RUN git config --global --add safe.directory $(pwd) && \
    make build-local && \
    ./kube-state-metrics version

FROM container-registry.oracle.com/os/oraclelinux:9-slim

COPY LICENSE THIRD_PARTY_LICENSES.txt olm/SECURITY.md /usr/share/licenses/
COPY --from=builder /workspace/go/src/github.com/oracle-cne/kube-state-metrics/kube-state-metrics /usr/bin

RUN microdnf update -y && \
    microdnf clean all && \
    test -d /LICENSES || ln -s /usr/share/licenses /LICENSES

USER nobody

ENTRYPOINT  [ "/usr/bin/kube-state-metrics" ]
