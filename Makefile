# ifneq (,$(wildcard ./.env))
#     include .env
#     export
#     ENV_FILE_PARAM = --env-file .env
# endif

up:
	@bash -c 'USERID=$$(id -g) docker-compose up -d --build'

create:
	@bash -c 'USERID=$$(id -g) docker-compose create --build'

# Что-то странное, но оно работает))
build:
	@bash -c 'USERID=$$(id -g) docker-compose build'

build-no-cache:
	@bash -c 'USERID=$$(id -g) docker-compose build --no-cache'

bash:
	@docker-compose exec server bash

start:
	@docker-compose start

restart:
	@docker-compose restart

stop:
	@docker-compose stop

down:
	@docker-compose down

console:
	@docker-compose exec server bash -c './$$GAMESERVER console'

docker-logs:
	@docker-compose logs server

# Aliases
r:
	@make restart

c:
	@make console

sp:
	@make stop

st:
	@make start
