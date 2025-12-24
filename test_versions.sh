#!/bin/bash

VERSIONS=("16" "18" "20" "22")
REPORT_FILE="versions.txt"

echo "Отчёт проверки установки зависимостей Node.js" > $REPORT_FILE
echo "Дата: $(date)" >> $REPORT_FILE
echo "============================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

for VERSION in "${VERSIONS[@]}"; do
    echo "Проверка Node.js $VERSION"

    echo "Node.js $VERSION" >> $REPORT_FILE
    echo "-----------------" >> $REPORT_FILE

    n $VERSION > /dev/null 2>&1

    if ! command -v node >/dev/null; then
        echo "Node.js не установлен" | tee -a $REPORT_FILE
        echo "" >> $REPORT_FILE
        continue
    fi

    NODE_VERSION=$(node -v)
    NPM_VERSION=$(npm -v)

    echo "Версия Node.js: $NODE_VERSION" >> $REPORT_FILE
    echo "Версия npm: $NPM_VERSION" >> $REPORT_FILE

    # Очистка старых зависимостей
    rm -rf node_modules package-lock.json

    # Установка зависимостей
    if npm install > /dev/null 2>&1; then
        echo "Зависимости установлены успешно" >> $REPORT_FILE
    else
        echo "Ошибка при установке зависимостей" >> $REPORT_FILE
    fi

    echo "" >> $REPORT_FILE
done

echo "Готово. Отчёт сохранён в $REPORT_FILE"
