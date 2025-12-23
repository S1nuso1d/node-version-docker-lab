#!/bin/sh

NODE_VERSION=$1

if [ -z "$NODE_VERSION" ]; then
  echo "Ошибка: не указана версия Node.js"
  echo "Пример: docker run my-node-builder 18"
  exit 1
fi

echo "Установка Node.js версии $NODE_VERSION"

# Установка Node.js через n
n $NODE_VERSION

echo "Проверка версии Node.js"
node -v
npm -v

echo "Установка зависимостей"
npm install

echo "Сборка приложения"
npm run build

echo "Готово"
