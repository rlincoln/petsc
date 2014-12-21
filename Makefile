ACCOUNTNAME = rlincoln

.DEFAULT_GOAL := help

help:
	@echo "Use \`make <target> [ACCOUNTNAME=<accountname>]' where <accountname> is"
	@echo "your docker account name and <target> is one of"
	@echo "  help     to display this help message"
	@echo "  image    to build the docker image"
	@echo "  login    to login to your docker account"
	@echo "  push     to push the image to the docker registry"

image:
	docker build -t $(ACCOUNTNAME)/petsc .

login:
	docker login -u $(ACCOUNTNAME)

dist: image login
	docker push $(ACCOUNTNAME)/petsc

