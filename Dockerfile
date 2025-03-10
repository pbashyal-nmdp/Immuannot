FROM --platform=linux/amd64 python:3.13-slim

RUN apt-get update && \
    apt-get install -y curl bzip2 && \
    apt-get clean autoremove --yes

RUN mkdir /temp && \
    curl -L https://github.com/lh3/minimap2/releases/download/v2.28/minimap2-2.28_x64-linux.tar.bz2 | tar  jxf - -C /temp && \
    cp /temp/minimap2-2.28_x64-linux/minimap2 /usr/local/bin/ && \
    cp /temp/minimap2-2.28_x64-linux/k8 /usr/local/bin/ && \
    cp /temp/minimap2-2.28_x64-linux/paftools.js /usr/local/bin/ && \
    rm -rf /temp/minimap2-2.28_x64-linux

RUN mkdir -p /refdata/ && \
    curl -L https://zenodo.org/records/10948964/files/Data-2024Feb02.tar.gz?download=1 | tar -xzvf - -C /refdata/

RUN mkdir -p /immuannot/scripts/ && \
    curl -L https://github.com/pbashyal-nmdp/Immuannot/archive/refs/tags/04092024.tar.gz | tar -C /immuannot/scripts/ -xzvf - Immuannot-04092024/scripts.pub.v3/ --strip-components=2

ENTRYPOINT ["bash"]
