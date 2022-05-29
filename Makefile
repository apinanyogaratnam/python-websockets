IMAGE := python-websockets
IMAGE_CLIENT := python-websockets-client
VERSION := 0.0.1
REGISTRY_URL := ghcr.io/apinanyogaratnam/${IMAGE}:${VERSION}
REGISTRY_URL_CLIENT := ghcr.io/apinanyogaratnam/${IMAGE_CLIENT}:${VERSION}
REGISTRY_URL_LATEST := ghcr.io/apinanyogaratnam/${IMAGE}:latest
REGISTRY_URL_LATEST_CLIENT := ghcr.io/apinanyogaratnam/${IMAGE_CLIENT}:latest

activate-venv:
	source venv/bin/activate

start-client:
	python3 -m http.server 3000

start-server:
	python3 main.py

build-server:
	docker build -t ${IMAGE} .

build-client:
	docker build -t ${IMAGE_CLIENT} client

run-server:
	docker run -d -p 8000:8000 ${IMAGE}

run-client:
	docker run -d -p 3000:3000 ${IMAGE_CLIENT}

exec:
	docker exec -it $(sha) /bin/sh

auth:
	grep -v '^#' .env.local | grep -e "CR_PAT" | sed -e 's/.*=//' | docker login ghcr.io -u USERNAME --password-stdin

tag:
	docker tag ${IMAGE} ${REGISTRY_URL}
	docker tag ${IMAGE} ${REGISTRY_URL_LATEST}
	git tag -m "v${VERSION}" v${VERSION}

tag-client:
	docker tag ${IMAGE_CLIENT} ${REGISTRY_URL_CLIENT}
	docker tag ${IMAGE_CLIENT} ${REGISTRY_URL_LATEST_CLIENT}

push:
	docker push ${REGISTRY_URL}
	docker push ${REGISTRY_URL_LATEST}
	docker push ${REGISTRY_URL_CLIENT}
	docker push ${REGISTRY_URL_LATEST_CLIENT}
	git push --tags

all:
	make build && make auth && make tag && make tag-client && make push
