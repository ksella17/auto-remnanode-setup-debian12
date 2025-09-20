#!/bin/bash

echo "=== Установка Remnano Node ==="

# Обновляем пакеты и ставим curl и sudo
apt-get update
apt-get install -y sudo curl

# Устанавливаем Docker
echo "=== Устанавливаем Docker ==="
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose-plugin

# Проверяем, что docker установлен
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker не установлен. Скрипт завершен."
    exit 1
fi

# Создаем рабочую директорию
mkdir -p /opt/remnanode
cd /opt/remnanode || { echo "Не удалось перейти в /opt/remnanode"; exit 1; }

# Создаем .env файл с портом
cat > .env <<EOF
APP_PORT=20002
EOF

# Спрашиваем про SSL ключ
read -rp "Хотите вставить SSL ключ в .env? (y/n): " ADD_SSL
if [ "$ADD_SSL" = "y" ] || [ "$ADD_SSL" = "Y" ]; then
    read -rp "Вставьте SSL ключ (одной строкой) и нажмите Enter: " SSL_CERT_INPUT
    echo "SSL_CERT=\"$SSL_CERT_INPUT\"" >> .env
fi

# Создаем docker-compose.yml
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

# Вопрос о запуске контейнера
read -rp "Запустить docker-compose.yml сейчас? (y/n): " RUN_DOCKER
if [ "$RUN_DOCKER" = "y" ] || [ "$RUN_DOCKER" = "Y" ]; then
    echo "Запускаем контейнер..."
    docker compose up -d
    echo "=== Контейнер запущен. Следим за логами... ==="
    docker compose logs -f
else
    echo "Скрипт завершен. Вы можете запустить контейнер позже командой:"
    echo "cd /opt/remnanode && docker compose up -d"
fi
