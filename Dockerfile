FROM ubuntu:focal

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TIMEZONE=Asia/Shanghai

# curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
ARG K8S_VERSION=1.19.2
ARG HELM_VERSION=3.3.3
ARG ISTIO_VERSION=1.7.1
ENV yq_version=3.4.0

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; export DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        locales tzdata ca-certificates \
        wget curl gnupg sudo \
  ; . /etc/os-release \
  ; sh -c "echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list" \
  ; curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add - \
  ; apt-get update -qq \
  ; apt-get install -y --no-install-recommends \
        skopeo buildah podman \
  \
  ; wget -q -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${yq_version}/yq_linux_amd64 \
    ; chmod +x /usr/local/bin/yq \
  \
  ; curl -L https://dl.k8s.io/v${K8S_VERSION}/kubernetes-client-linux-amd64.tar.gz \
    | tar zxf - --strip-components=3 -C /usr/local/bin kubernetes/client/bin/kubectl \
  ; chmod +x /usr/local/bin/kubectl \
  \
  ; curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        | tar zxvf - -C /usr/local/bin linux-amd64/helm --strip-components=1 \
  \
  ; curl -L https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz \
        | tar zxvf - -C /usr/local/bin istio-${ISTIO_VERSION}/bin/istioctl --strip-components=2 \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
		-e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
		-e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
	; locale-gen \
  ; sed -i 's/^.*\(%sudo.*\)ALL$/\1NOPASSWD:ALL/g' /etc/sudoers \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
