IMAGINE_CMD?="imaginekube"
IMAGINE_TEST_CLUSTER_NAME?=twingate-test
IMAGINE_KUBECONFIG?=kubeconfig.$(IMAGINE_TEST_CLUSTER_NAME)
KUBECTL?=kubectl --kubeconfig=$(IMAGINE_KUBECONFIG)


.PHONY: cluster-setup
cluster-setup:
	@echo "Creating $(IMAGINE_TEST_CLUSTER_NAME)"
	@$(IMAGINE_CMD) k3s create $(IMAGINE_TEST_CLUSTER_NAME) -n 3 --size g3.k3s.small --region NYC1 --wait
	@$(IMAGINE_CMD) k3s config $(IMAGINE_TEST_CLUSTER_NAME) > $(IMAGINE_KUBECONFIG)


.PHONY: cluster-teardown
cluster-teardown:
	@echo "Tearing down test cluster!"
	@$(IMAGINE_CMD) k3s remove -y $(IMAGINE_TEST_CLUSTER_NAME) || true
	@rm $(IMAGINE_KUBECONFIG)


.PHONY: deploy-connector
deploy-connector:
	@$(KUBECTL) apply -f app.yaml


.PHONY: deploy-internal-site
internal-site:
	@$(KUBECTL) apply -f test/internal-site.yaml


.PHONY: deploy
deploy: deploy-connector internal-site
