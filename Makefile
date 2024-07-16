include Settings.mk
include Colours.mk
include srcs/.env

VOLUME_DIR=/home/loyc/data
WORDPRESS_DIR=$(VOLUME_DIR)/wordpress
MARIADB_DIR=$(VOLUME_DIR)/mariadb

$(MARIADB_DIR): $(VOLUME_DIR)
	$(HIDE) mkdir -p $(MARIADB_DIR)

$(WORDPRESS_DIR): $(VOLUME_DIR)
	$(HIDE) mkdir -p $(WORDPRESS_DIR)

$(VOLUME_DIR):
	$(HIDE) mkdir -p $(VOLUME_DIR)

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
all: run

run: up
up: $(MARIADB_DIR) $(WORDPRESS_DIR)
	@echo "$(YELLOW)\nStarting all services\n $(DEFCOL)"
	$(HIDE) docker compose $(FLAGS) ./srcs/docker-compose.yml up --build
	@echo "$(GREEN)\nAll services up and running\n $(DEFCOL)"

close: down
down:
	@echo "$(YELLOW)\nStopping all services\n $(DEFCOL)"
	$(HIDE) docker compose $(FLAGS) ./srcs/docker-compose.yml down
	@echo "$(MAGENTA)\nAll services down\n $(DEFCOL)"

rerun: re
re: $(MARIADB_DIR) $(WORDPRESS_DIR)
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

	@echo "$(YELLOW)\nRemoving volumes\n $(DEFCOL)"
	$(HIDE) sudo rm -rf $(WORDPRESS_DIR) $(MARIADB_DIR) $(VOLUME_DIR)
	@echo "$(RED)\nVolumes removed\n $(DEFCOL)\n"

# Removes EVERYTHING
fclear: fclean
fclean: clean
	@echo "$(YELLOW)\nRemoving all caches\n $(DEFCOL)"
	docker builder prune --all
	@echo "$(RED)\nCaches removed\n $(DEFCOL)\n"