VERSION=5.4
OS=rhel7
SERVER=apache

IMAGE_NAME=openshift/php:${VERSION}-${OS}-${SERVER}

build:
	docker build -t $(IMAGE_NAME) .

#.PHONY: test
#test: build
#	./test/run
