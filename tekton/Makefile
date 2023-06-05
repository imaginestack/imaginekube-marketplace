# Moving to LTS Version - Yearly Support
VERSION?="v0.44.0"
# For cli directly installed
IMAGINE_CMD?="imaginekube"
# For Docker
#IMAGINE_CMD=docker run -it --rm -v $HOME/.imaginekube.json:/.imaginekube.json imaginekube/cli:latest
IMAGINE_TEST_CLUSTER_NAME?=tekton-test
IMAGINE_KUBECONFIG?=kubeconfig.$(IMAGINE_TEST_CLUSTER_NAME)
KUBECTL?=kubectl --kubeconfig=$(IMAGINE_KUBECONFIG)

.PHONY: build
build: app.yaml

app.yaml:
	@curl https://storage.googleapis.com/tekton-releases/pipeline/previous/$(VERSION)/release.yaml > app.yaml
	@echo "---" >> app.yaml
	@curl https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml >> app.yaml
	@echo "---" >> app.yaml
	@curl https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml >> app.yaml

	# Test final app.yaml for validity
	@echo "Testing validity of app.yaml"
	@kubectl apply -f app.yaml --dry-run=client > /dev/null
	@echo "Clean app.yaml generated"

.PHONY: clean
clean: 
	@rm app.yaml

.PHONY: test
test: $(IMAGINE_KUBECONFIG) test-noclean cluster-clean

.PHONY: test-keep
test-keep: $(IMAGINE_KUBECONFIG) test-noclean

.PHONY: test-noclean
test-noclean:
	@echo "Applying manifest and test run"
	@$(KUBECTL) apply -f app.yaml
	@$(KUBECTL) create -f test-manifests/1-task.yaml 
	@$(KUBECTL) create -f test-manifests/2-taskrun.yaml 
	@sleep 10
	@echo "Checking status of test run"
	@$(KUBECTL) get -n default taskrun -l tekton.dev/task=hello -ojson | jq -r .items[0].status.conditions[0].type | grep -q Succeeded
	@echo "Success!"



.PHONY: cluster-clean
cluster-clean:
	@echo "Tearing down test cluster!"
	@$(IMAGINE_CMD) k3s remove -y $(IMAGINE_TEST_CLUSTER_NAME) || true
	@rm $(IMAGINE_KUBECONFIG) 

$(IMAGINE_KUBECONFIG):
	@echo "Creating $(IMAGINE_TEST_CLUSTER_NAME)"
	@$(IMAGINE_CMD) k3s create $(IMAGINE_TEST_CLUSTER_NAME) -n 3 --size g4s.kube.small --applications metrics-server --wait
	@$(IMAGINE_CMD) k3s config $(IMAGINE_TEST_CLUSTER_NAME) > $(IMAGINE_KUBECONFIG)
