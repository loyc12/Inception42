include Settings.mk
include Colours.mk

#------------------------------------------------------------------------------#
#                                   GENERICS                                   #
#------------------------------------------------------------------------------#

# Special variables
DEFAULT_GOAL: all
.PHONY: all build up \
		close down \
		rerun re \
		clear clean \

#------------------------------------------------------------------------------#
#                                 BASE TARGETS                                 #
#------------------------------------------------------------------------------#

# For standard compilation
all: up

build: up
up:
	@echo "$(YELLOW)\nStarting all services\n $(DEFCOL)"
	$(HIDE) docker compose -f ./srcs/docker-compose.yml up -d --build
	@echo "$(GREEN)\nAll services up and running\n $(DEFCOL)"

close: down
down:
	@echo "$(YELLOW)\nStopping all services\n $(DEFCOL)"
	$(HIDE) docker compose -f ./srcs/docker-compose.yml down
	@echo "$(MAGENTA)\nAll services down\n $(DEFCOL)"

rerun: re
re:
	@echo "$(YELLOW)\nRestarting all services\n $(DEFCOL)"
	$(HIDE) docker compose -f ./srcs/docker-compose.yml down
	$(HIDE) docker compose -f ./srcs/docker-compose.yml up -d --build
	@echo "$(GREEN)\nAll services up and running\n $(DEFCOL)"

#------------------------------------------------------------------------------#
#                               CLEANING TARGETS                               #
#------------------------------------------------------------------------------#

# Removes objects
clear: clean
clean: down
	@echo "$(YELLOW)\nRemoving all services\n $(DEFCOL)"
	$(HIDE) docker stop $$(docker ps -qa);\
	$(HIDE) docker rm $$(docker ps -qa);\
	$(HIDE) docker rmi -f $$(docker images -qa);\
	$(HIDE) docker volume rm $$(docker volume ls -q);\
	$(HIDE) docker network rm $$(docker network ls -q);\
	@echo "$(RED)\nAll services removed\n $(DEFCOL)"
