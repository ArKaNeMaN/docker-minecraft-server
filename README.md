# Dockerized Minecraft server

За основу была взята [докеризированная версия LinuxGSM](https://github.com/GameServerManagers/LinuxGSM-Docker).

## Использование

### Установка

[Установить Docker](https://docs.docker.com/engine/install/)

```shell
# Установка make для использования команд из Makefile
sudo apt install make

mkdir server
cd server

# Клонирование репозитория со всеми файлами для сборки
git clone https://github.com/ArKaNeMaN/docker-minecraft-server .

# Создание файла .env из шаблона
cp .env.example .env
nano .env
```

В открывшемся файле настроить все переменные, сохранить (`Ctrl+S`) и закрыть (`Ctrl+X`).

```shell
# Сборка и запуск контейнера
make up
```

Первый запуск будет долгим, из-за сборки образа.

Все файлы сервера будут лежать в папке `./server/`.

__ВНИМАНИЕ!__ В файле server.properties порт изменять не надо.

### Взаимодействие

```shell
# Запустить сервер
make start

# Открыть консоль
make console

# Остановить сервер
make stop
```
