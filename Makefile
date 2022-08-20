# ifneq (,$(wildcard ./.env))
#     include .env
#     export
#     ENV_FILE_PARAM = --env-file .env
# endif

up:
	@bash -c 'USERID=$$(id -g) docker-compose up -d'
# Что-то странное, но оно работает))
build:
	@bash -c 'USERID=$$(id -g) docker-compose build'

start:
	@docker-compose start

stop:
	@docker-compose stop

down:
	@docker-compose down

console:
	@docker-compose exec server bash -c './$$GAMESERVER console'

docker-logs:
	@docker-compose logs server

# Aliases
c:
	@make console

sp:
	@make stop

st:
	@make start
