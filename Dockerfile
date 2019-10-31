FROM ubuntu:18.10 AS build

RUN apt-get update -y \
 && apt-get install -y \
      wget \
      golang git-core go-md2man \
      libglib2.0-dev

ARG BUILDTAGS=""
ARG skopeo_version=0.1.40
ARG skopeo_url=https://github.com/containers/skopeo/archive/v${skopeo_version}.tar.gz
ENV GOPATH=/
RUN mkdir -p $GOPATH/src/github.com/containers/skopeo && \
    wget -O- ${skopeo_url} \
        | tar zxf - --strip-components=1 \
          -C $GOPATH/src/github.com/containers/skopeo && \
    cd $GOPATH/src/github.com/containers/skopeo && \
    make binary-local-static DISABLE_CGO=1 && \
    mkdir -p /etc/containers && \
    cp default-policy.json /etc/containers/policy.json && \
    cp skopeo /skopeo && \
    ./skopeo --help

FROM frolvlad/alpine-glibc

COPY --from=build /skopeo /skopeo
COPY --from=build /etc/containers /etc/containers

RUN apk add --no-cache ca-certificates
WORKDIR /world
ENTRYPOINT [ "/skopeo" ]