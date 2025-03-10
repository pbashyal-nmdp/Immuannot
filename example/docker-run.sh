docker run --platform=linux/amd64 \
    -u $(id -u):$(id -g) \
    -v ${PWD}:/example \
    nmdpbioinformatics/immuannot:latest \
    /example/example.sh

