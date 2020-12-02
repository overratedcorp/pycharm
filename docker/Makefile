AWSCLI_VERSION ?= 2.1.2
AWSU_VERSION ?= 2.3.2
DOCKER_VERSION ?= 19.03.9
PACKER_VERSION ?= 1.6.5
PYCHARM_VERSION ?= 2020.2.3
PRE_COMMIT_VERSION ?= 2.7.1
SHELLCHECK_VERSION ?= 0.7.1
TFENV_VERSION ?= 2.0.0

$(warning ---> building version: [$(RELEASE_VERSION)])
DOCKER_REF = rezultat/pycharm:$(RELEASE_VERSION)


build:
	@docker build \
		--build-arg awscli_version='$(AWSCLI_VERSION)' \
		--build-arg awsu_version='$(AWSU_VERSION)' \
		--build-arg docker_version='$(DOCKER_VERSION)' \
		--build-arg packer_version='$(PACKER_VERSION)' \
		--build-arg pycharm_version='$(PYCHARM_VERSION)' \
		--build-arg pre_commit_version='$(PRE_COMMIT_VERSION)' \
		--build-arg shellcheck_version='$(SHELLCHECK_VERSION)' \
		--build-arg tfenv_version='$(TFENV_VERSION)' \
		--tag '$(DOCKER_REF)' \
		.
	@docker push '$(DOCKER_REF)'

.PHONY: build
