img:
    docker build -t registry.d/drone-k8s . -f Dockerfile-drone-test
    docker push registry.d/drone-k8s