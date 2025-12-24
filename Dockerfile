FROM node:slim

# Устанавливаем необходимые утилиты
RUN apt-get update && apt-get install -y curl wget procps bash && rm -rf /var/lib/apt/lists/*

# Устанавливаем n для смены версий Node
RUN npm install -g n

WORKDIR /app
COPY . /app
RUN chmod +x test_versions.sh

ENTRYPOINT ["/bin/bash"]
