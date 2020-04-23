FROM ubuntu:focal

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TIMEZONE=Asia/Shanghai

# curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
ARG K8S_VERSION=1.18.2
ARG HELM_VERSION=3.2.0
ARG ISTIO_VERSION=1.5.1

RUN set -eux \
  ; apt-get update \
  ; apt-get upgrade -y \
  ; export DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        locales tzdata ca-certificates \
        wget curl gnupg sudo \
  ; echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' \
        > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
  ; wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_10/Release.key -O- \
        | sudo apt-key add - \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        skopeo buildah podman \
  \
  ; curl -L https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl \
        > /usr/bin/kubectl \
  ; chmod +x /usr/bin/kubectl \
  \
  ; curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        | tar zxvf - -C /usr/bin linux-amd64/helm --strip-components=1 \
  \
  ; curl -L https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz \
        | tar zxvf - -C /usr/bin istio-${ISTIO_VERSION}/bin/istioctl --strip-components=2 \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
		-e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
		-e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
	; locale-gen \
  ; sed -i 's/^.*\(%sudo.*\)ALL$/\1NOPASSWD:ALL/g' /etc/sudoers \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
