#!/bin/bash

NODE_VERSION=$1
APP_FILE="index.js"

if [ -z "$NODE_VERSION" ]; then
  echo "Ошибка: не указана версия Node.js"
  echo "Пример: ./test_resources.sh 18"
  exit 1
fi

echo "Установка Node.js версии $NODE_VERSION"
n $NODE_VERSION >/dev/null

echo "Версия Node.js: $(node -v)"
echo

START_TIME=$(date +%s)

echo "Запуск приложения"
node app/$APP_FILE &
APP_PID=$!

echo "PID процесса: $APP_PID"
echo
echo "Мониторинг ресурсов (обновление каждую секунду)"
echo "-----------------------------------------------"

MAX_CPU=0
MAX_MEM=0

while kill -0 $APP_PID 2>/dev/null; do
  CPU_USAGE=$(ps -p $APP_PID -o %cpu --no-headers | awk '{print $1}')
  MEM_USAGE=$(ps -p $APP_PID -o rss --no-headers | awk '{print $1}')

  MEM_MB=$(awk "BEGIN {printf \"%.2f\", $MEM_USAGE/1024}")

  echo "[PID $APP_PID] CPU: $CPU_USAGE % | RAM: $MEM_MB MB"

  # Максимальные значения
  CPU_INT=$(echo "$CPU_USAGE" | awk '{printf "%d", $1}')
  if [ "$CPU_INT" -gt "$MAX_CPU" ]; then
    MAX_CPU=$CPU_USAGE
  fi

  if [ "$MEM_USAGE" -gt "$MAX_MEM" ]; then
    MAX_MEM=$MEM_USAGE
  fi

  sleep 1
done

wait $APP_PID

END_TIME=$(date +%s)
EXEC_TIME=$((END_TIME - START_TIME))
MAX_MEM_MB=$(awk "BEGIN {printf \"%.2f\", $MAX_MEM/1024}")

echo
echo "========== ИТОГОВЫЙ ОТЧЁТ =========="
echo "Версия Node.js:        $(node -v)"
echo "Время выполнения:     $EXEC_TIME сек"
echo "Максимальная CPU:     $MAX_CPU %"
echo "Максимальная память: $MAX_MEM_MB MB"
echo "==================================="
echo
read -p "Нажмите Enter для выхода..."
