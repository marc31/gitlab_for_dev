up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

stop:
	docker compose stop

logs:
	docker compose logs -f

get-root-password:
	docker compose exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
	
shell:
	docker compose exec -it gitlab /bin/bash

config-reload:
	docker compose exec -it gitlab gitlab-ctl reconfigure

config-show:
	docker compose exec -it gitlab gitlab-ctl show-config

PHONY: up down restart stop logs get-root-password shell config-reload config-show