FROM node:slim

RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g n

WORKDIR /app

COPY app/ /app/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
