FROM debian:buster-slim

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TIMEZONE=Asia/Shanghai

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
  ; apt-get autoremove -y wget \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        skopeo buildah podman \
  ; export k8s_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
  ; curl -L https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/linux/amd64/kubectl \
        > /usr/bin/kubectl \
  ; chmod +x /usr/bin/kubectl \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
		-e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
		-e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
	; locale-gen \
  ; sed -i 's/^.*\(%sudo.*\)ALL$/\1NOPASSWD:ALL/g' /etc/sudoers \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
