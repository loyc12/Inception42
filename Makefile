include Settings.mk
include Colours.mk
include srcs/.env

#------------------------------------------------------------------------------#
#                                   GENERICS                                   #
#------------------------------------------------------------------------------#

# Special variables
DEFAULT_GOAL: all
.PHONY: all build up \
		close down \
		run re \
		clear clean \
		fclean fclear \

# add -d to make it run in the background
FLAGS = -f

#------------------------------------------------------------------------------#
#                                 BASE TARGETS                                 #
#------------------------------------------------------------------------------#

# For standard compilation
all: up

run: build
build: up
up:
	@echo "$(YELLOW)\nStarting all services\n $(DEFCOL)"
	$(HIDE) docker compose $(FLAGS) ./srcs/docker-compose.yml up --build
	@echo "$(GREEN)\nAll services up and running\n $(DEFCOL)"

close: down
down:
	@echo "$(YELLOW)\nStopping all services\n $(DEFCOL)"
	$(HIDE) docker compose $(FLAGS) ./srcs/docker-compose.yml down
	@echo "$(MAGENTA)\nAll services down\n $(DEFCOL)"

rerun: re
re:
	@echo "$(YELLOW)\nRestarting all services\n $(DEFCOL)"
	$(HIDE) docker compose $(FLAGS) ./srcs/docker-compose.yml down
	$(HIDE) docker compose $(FLAGS) ./srcs/docker-compose.yml up --build
	@echo "$(GREEN)\nAll services up and running\n $(DEFCOL)"

#------------------------------------------------------------------------------#
#                               CLEANING TARGETS                               #
#------------------------------------------------------------------------------#

# Removes objects
clear: clean
clean: down
	@echo "$(YELLOW)\nRemoving all services\n $(DEFCOL)"
	$(HIDE) if [ "$$(docker ps -qa)" ]; then \
		docker stop $$(docker ps -qa); \
		docker rm $$(docker ps -qa); \
	fi
	$(HIDE) if [ "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi
	$(HIDE) if [ "$$(docker network ls -q | wc -l)" -gt 3 ]; then \
		docker network rm $$(docker network ls -q | sed -n '4p'); \
	fi
	$(HIDE) if [ "$$(docker images -qa)" ]; then \
		docker rmi -f $$(docker images -qa); \
	fi
	@echo "$(RED)All services removed\n $(DEFCOL)"

	@echo "$(YELLOW)\nRemoving /data directory\n $(DEFCOL)"
	$(HIDE) sudo --prompt="TYPE ROOT PASSWORD" rm -rf srcs/data
	@echo "$(RED)/data directory removed\n $(DEFCOL)\n"

# Removes EVERYTHING
fclear: fclean
fclean: clean
	@echo "$(YELLOW)\nRemoving all caches\n $(DEFCOL)"
	docker builder prune --all
	@echo "$(RED)/caches removed\n $(DEFCOL)\n"