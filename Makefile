SHELL := /bin/bash

run: 
	scripts/permiss.sh && docker-compose up

build: 
	scripts/permiss.sh && docker-compose up --build

flushredis:
	docker exec -it redis.ghtk.vn redis-cli flushAll

ssh:
	docker exec -it ghtk_php zsh
