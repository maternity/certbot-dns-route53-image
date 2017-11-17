registry = quay.io
repository = maternity
name = certbot-dns-route53
version = latest
tag = $(repository)/$(name):$(version)

rebuild-image ?=


image:
ifeq "$(rebuild-image)" ""
	$(MAKE) pull || $(MAKE) build
else
	$(MAKE) build
endif

build:
	docker build -t $(tag) .
	@grep -sqFx $(tag) .unpushed || echo $(tag) >>.unpushed

push:
	$(foreach tag,$(shell cat .unpushed),\
	    docker tag $(tag) $(registry)/$(tag) &&\
	    docker push $(registry)/$(tag))
	@$(RM) .unpushed

pull:
	docker pull $(registry)/$(tag)
	docker tag $(registry)/$(tag) $(tag)
