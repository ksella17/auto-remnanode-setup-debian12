#!/bin/sh

echo "=== Установка Remnano Node ==="

apt-get update
apt-get install -y sudo curl

mkdir -p /opt/remnanode
cd /opt/remnanode || { echo "Не удалось перейти в /opt/remnanode"; exit 1; }

cat > .env <<EOF
APP_PORT=20002
EOF

# Вставка SSL ключа
printf "Хотите вставить SSL ключ в .env? (y/n): "
read ADD_SSL
case "$ADD_SSL" in
  [Yy]*) 
      printf "Вставьте SSL ключ (одной строкой) и нажмите Enter: "
      read SSL_CERT_INPUT
      echo "SSL_CERT=\"$SSL_CERT_INPUT\"" >> .env
      ;;
  *) 
      echo "Пропускаем SSL ключ."
      ;;
esac

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

# Запуск контейнера
printf "Запустить docker-compose.yml сейчас? (y/n): "
read RUN_DOCKER
case "$RUN_DOCKER" in
  [Yy]*) 
      docker compose up -d
      docker compose logs -f
      ;;
  *) 
      echo "Скрипт завершен. Вы можете запустить контейнер позже командой:"
      echo "cd /opt/remnanode && docker compose up -d"
      ;;
esac
