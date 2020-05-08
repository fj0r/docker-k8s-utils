# k8su

```shell
docker run --rm \
    -v /run/docker.sock:/docker.sock \
    nnurphy/skopeo copy \
    --dest-tls-verify=false \
    --dest-compress-format=zstd \
    --dest-compress-level=12 \
    --src-daemon-host=unix:///docker.sock \
    --dest-daemon-host=http://172.178.5.21:12345 \
    docker-daemon:{{img}} docker-daemon:{{img}}
```

# utils
date        | kubectl   | helm      | istioctl  | podman    | buildah   | skopeo
------------|-----------|-----------|-----------|-----------|-----------|--------
~           | 1.18.2    | 3.2.0     | 1.5.2     | 1.9.0     | 1.14.8    | 0.2.0
2020/05/08  |           | 3.2.1     |           | 1.9.1     |           |
