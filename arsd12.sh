#!/bin/bash

echo "=== Установка Remnano Node ==="

# Обновляем пакеты
echo "Обновляем пакеты..."
apt-get update
apt-get install -y sudo curl

# Создаем рабочую директорию
echo "Создаем рабочую директорию..."
mkdir -p /opt/remnanode
cd /opt/remnanode || { echo "Не удалось перейти в /opt/remnanode"; exit 1; }

# Создаем .env файл с портом
echo "Создаем .env файл..."
cat > .env <<EOF
APP_PORT=20002
EOF

# Спрашиваем про SSL ключ
echo ""
read -rp "Хотите вставить SSL ключ в .env? (y/n): " ADD_SSL
if [[ "$ADD_SSL" =~ ^[Yy]$ ]]; then
    read -rp "Вставьте SSL ключ (одной строкой) и нажмите Enter: " SSL_CERT_INPUT
    echo "Добавляем SSL ключ в .env..."
    echo "SSL_CERT=\"$SSL_CERT_INPUT\"" >> .env
fi

# Создаем docker-compose.yml
echo "Создаем docker-compose.yml..."
cat > docker-compose.yml <<EOF
services:
    remnanode:
        container_name: remnanode
        hostname: remnanode
        image: remnawave/node:2.0.0
        restart: always
        network_mode: host
        env_file:
            - .env
EOF

echo "=== Установка завершена! ==="
echo "Файлы созданы в /opt/remnanode/"

# Вопрос о запуске контейнера
echo ""
read -rp "Запустить docker-compose.yml сейчас? (y/n): " RUN_DOCKER
if [[ "$RUN_DOCKER" =~ ^[Yy]$ ]]; then
    echo "Запускаем контейнер..."
    docker compose up -d
    echo "=== Контейнер запущен. Следим за логами... ==="
    docker compose logs -f
else
    echo "Скрипт завершен. Вы можете запустить контейнер позже командой:"
    echo "cd /opt/remnanode && docker compose up -d"
fi
