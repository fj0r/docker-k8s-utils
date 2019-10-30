```shell
docker run --rm \
    -v /run/docker.sock:/docker.sock \
    nnurphy/skopeo copy \
    --dest-tls-verify=false \
    --src-daemon-host=unix:///docker.sock \
    --dest-daemon-host=http://172.178.5.21:12345 \
    docker-daemon:{{img}} docker-daemon:{{img}}
```