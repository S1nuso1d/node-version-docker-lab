FROM node:slim

RUN apt-get update \
    && apt-get install -y curl procps bash \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g n

WORKDIR /app

COPY . /app

RUN chmod +x entrypoint.sh test_resources.sh

ENTRYPOINT ["/bin/bash"]
