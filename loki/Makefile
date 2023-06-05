VERSION?="2.1.2"
CHART_URL?="https://grafana.github.io/loki/charts"
# For cli directly installed
#IMAGINE_CMD?="imaginekube"
# For Docker
IMAGINE_CMD?=docker run -it --rm -v $$HOME/.imaginekube.json:/.imaginekube.json imaginekube/cli:latest
IMAGINE_TEST_CLUSTER_NAME?=loki-test
IMAGINE_KUBECONFIG?=kubeconfig.$(IMAGINE_TEST_CLUSTER_NAME)
KUBECTL?=kubectl --kubeconfig=$(IMAGINE_KUBECONFIG)

# Depends on yq from https://github.com/mikefarah/yq for parsing
.PHONY: latest_version
latest_version:
	@curl -s $(CHART_URL)/index.yaml | yq r - 'entries.loki-stack[*].version' | sort -t "." -k1,1n -k2,2n -k3,3n | tail -1

.PHONY: build
build: app.yaml

app.yaml:
# Whatever commands are needed to build the app.yaml.  Kustomize example below
	@sed "s/VERSION/$(VERSION)/" app.yaml.tmpl > app.yaml

	# Test final app.yaml for validity
	@echo "Testing validity of app.yaml"
	@$(KUBECTL) apply -f app.yaml --dry-run=client > /dev/null
	@echo "Clean app.yaml generated"

.PHONY: clean
clean:
	@rm app.yaml

.PHONY: test
test: $(IMAGINE_KUBECONFIG) test-noclean cluster-clean

.PHONY: test-keep
test-keep: $(IMAGINE_KUBECONFIG) test-noclean

.PHONY: test-noclean
# Took nearly two minutes for loki to come up...testing look to compensate 
test-noclean:
	@echo "Applying manifest and test run"
	@$(KUBECTL) apply -f app.yaml
	@sleep 30
	@$(KUBECTL) create -f test-manifests/testjob.yaml  
	@sleep 10
	@echo "Checking status of test run"
	@for i in $$(seq 1 10); do \
		echo Test $$i; \
		if $(KUBECTL) get job testjob -n loki -ojson | jq -r .status.conditions[0].type | grep -q Complete; then \
			break; \
		else \
			sleep 20; \
		fi; \
		if [ $$i -gt 9 ]; then \
			exit 1; \
		fi; \
		done
	@echo "Success!"

.PHONY: cluster-clean
cluster-clean:
	@echo "Tearing down test cluster!"
	@$(IMAGINE_CMD) k3s remove -y $(IMAGINE_TEST_CLUSTER_NAME) || true
	@rm $(IMAGINE_KUBECONFIG) 

$(IMAGINE_KUBECONFIG):
	@echo "Creating $(IMAGINE_TEST_CLUSTER_NAME)"
	@$(IMAGINE_CMD) k3s create $(IMAGINE_TEST_CLUSTER_NAME) -n 3 --size g3.k3s.small -a prometheus-operator --wait
	@$(IMAGINE_CMD) k3s config $(IMAGINE_TEST_CLUSTER_NAME) > $(IMAGINE_KUBECONFIG)
	@echo "Waiting for all 3 nodes to come up"
	@for i in $$(seq 1 10); do echo Test $$i; if [ "$$($(KUBECTL) get nodes | grep Ready | wc -l)" = "3" ]; then break; else sleep 10; fi; done
