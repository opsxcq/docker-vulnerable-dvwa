NAME ?= dvwa
APPLICATION_NAME ?= jzarris/dvwa
 
build:
	docker build --tag ${APPLICATION_NAME} .

buildx:
	docker buildx build --platform=linux/amd64 --load --tag ${APPLICATION_NAME} .

run:
	docker run --name ${NAME} -d ${APPLICATION_NAME}
	
stop:
	docker stop ${NAME}
	
remove:
	docker rm ${NAME}
	
clean:
	docker stop ${NAME}
	docker rm ${NAME}
	
exec:
	docker exec -it ${NAME} /bin/bash

buildrun:
	docker build --tag ${APPLICATION_NAME} .
	docker stop ${NAME}
	docker rm ${NAME}
	docker run --name ${NAME} -d ${APPLICATION_NAME}

logs:
	docker logs ${NAME} --follow

push:
	docker push jzarris/dvwa
	
