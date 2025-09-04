#!/bin/bash

# Скрипт установки Remnano Node
echo "=== Установка Remnano Node ==="

# Обновляем пакеты
echo "Обновляем пакеты..."
sudo apt-get update
sudo apt-get install -y curl

# Устанавливаем Docker
echo "Устанавливаем Docker..."
sudo curl -fsSL https://get.docker.com | sh

# Создаем директорию
echo "Создаем рабочую директорию..."
sudo mkdir -p /opt/remnanode
cd /opt/remnanode || exit

# Создаем .env файл
echo "Создаем .env файл..."
sudo tee .env > /dev/null <<EOF
APP_PORT=20002
EOF

# Создаем docker-compose.yml
echo "Создаем docker-compose.yml..."
sudo tee docker-compose.yml > /dev/null <<EOF
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
echo ""
echo "Дальнейшие действия:"
echo "1. Добавьте SSL конфигурацию в docker-compose.yml"
echo "2. Запустите: cd /opt/remnanode && sudo docker compose up -d"
echo "3. Логи: sudo docker compose logs -f -t"
