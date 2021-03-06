CHART_REPO := $(or $(CHART_REPO),jenkins-x-chartmuseum:8080)
CURRENT=$(shell pwd)
NAME := $(or $(APP_NAME),$(CURRENT))
ORG := $(or $(ORG),activiti)
OS := $(shell uname)
VERSION := $(or $(VERSION),$(shell cat ../../VERSION))
HELM_RELEASE := $(or $(HELM_RELEASE), $(NAME))
RELEASE_ARTIFACT := $(or $(RELEASE_ARTIFACT),$(NAME))

GITHUB_CHARTS_REPO := $(or $(GITHUB_CHARTS_REPO),$(shell git config --get remote.origin.url))
GITHUB_CHARTS_BRANCH := $(or $(GITHUB_CHARTS_BRANCH),gh-pages)

build: clean
	helm init --client-only
	helm repo add charts_activiti https://activiti.github.io/activiti-cloud-charts/
	helm repo add activiti-cloud-helm-charts https://activiti.github.io/activiti-cloud-helm-charts/
	helm dependency build
	helm lint

dry-run: 
	helm upgrade ${HELM_RELEASE} . --install --debug --dry-run

$(NAME)-$(VERSION).tgz: build
	helm package .

package: $(NAME)-$(VERSION).tgz

preview: version package dry-run release

install: build
	helm upgrade ${HELM_RELEASE} . --install

upgrade: clean build
	helm upgrade ${HELM_RELEASE} .

delete:
	helm delete --purge ${HELM_RELEASE}

clean:
	rm -rf requirements.lock
	rm -rf charts
	rm -rf ${NAME}*.tgz

release: package
	curl  -u $(CHARTMUSEUM_CREDS_USR):$(CHARTMUSEUM_CREDS_PSW) --data-binary "@$(NAME)-$(VERSION).tgz" $(CHART_REPO)/api/charts
	rm -rf ${NAME}*.tgz%

github:
	$(eval GITHUB_CHARTS_DIR := $(shell basename $(GITHUB_CHARTS_REPO) .git))
	[[ -d $(GITHUB_CHARTS_DIR) ]] || git clone -b "$(GITHUB_CHARTS_BRANCH)" "$(GITHUB_CHARTS_REPO)" $(GITHUB_CHARTS_DIR)
	cp "$(NAME)-$(VERSION).tgz" $(GITHUB_CHARTS_DIR)
	cd $(GITHUB_CHARTS_DIR) && \
	   helm repo index . && \
	   git add . && \
	   git status && \
	   git commit -m "fix:(version) release $(NAME)-$(VERSION).tgz" && \
	   git pull && \
	   git push origin "$(GITHUB_CHARTS_BRANCH)"
	rm -rf $(GITHUB_CHARTS_DIR)

version: 
	sed -i -e "s/version:.*/version: $(VERSION)/" Chart.yaml
	sed -i -e "s|repository: .*|repository: $(DOCKER_REGISTRY)/$(ORG)/$(NAME)|" values.yaml
	sed -i -e "s/tag: .*/tag: $(VERSION)/" values.yaml

tag: version
	git add --all
	git commit -m "release $(VERSION)" --allow-empty # if first release then no verion update is performed
	git tag -fa v$(VERSION) -m "Release version $(VERSION)"
	git push origin v$(VERSION)

updatebot/push-version: 
	@echo Resolving push versions for artifacts........
	$(eval ACTIVITI_CLOUD_MESSAGES_VERSION=$(shell mvn help:evaluate -Dexpression=activiti-cloud-messages-service.version -q -DforceStdout -f ../../pom.xml))
	$(eval MAVEN_VERSIONS=org.activiti.cloud.examples:activiti-cloud-messages $(VERSION) org.activiti.cloud.messages:activiti-cloud-messages-dependencies $(ACTIVITI_CLOUD_MESSAGES_VERSION))

	@echo Doing updatebot push-version.....
	for number in 1 2; do \
		updatebot -d ../../ push-version --kind maven $(MAVEN_VERSIONS); \
		rm -rf ../../.updatebot-repos/; \
		sleep $$[ ( $$RANDOM % 10 )  + 1 ]s; \
	done
