build: ## Create the dev-dependencies zarf package
	zarf package create .

clean: ## Cleanup downloaded files and packages
	rm zarf-uploader/packages/generic/*
	rm zarf-uploader/packages/pypi/*
	rm zarf-uploader/packages/npm/*
	rm zarf-package-dev-dependencies-amd64.tar.zst

test-deploy: ## Test deploying the package with fresh certificates
	cp zarf-config.example.toml zarf-config.toml
	$(MAKE) setup-certificates
	zarf package deploy zarf-package-dev-dependencies-amd64.tar.zst --confirm

setup-certificates: generate-certificates ## Generate tls certificates and add them to the zarf-config.toml
	sed -i -e "s/tls_key = '.*'/tls_key = '$(shell cat tls.key | base64 | tr -d '\n')'/g" zarf-config.toml
	sed -i -e "s/tls_crt = '.*'/tls_crt = '$(shell cat tls.crt | base64 | tr -d '\n')'/g" zarf-config.toml
	sed -i -e "s/tls_ca = '.*'/tls_ca = '$(shell cat tls.ca | base64 | tr -d '\n')'/g" zarf-config.toml

generate-certificates:
	zarf tools pki agent-redirector.zarf.svc.cluster.local \
		--sub-alt-name github.com \
		--sub-alt-name registry.npmjs.org \
		--sub-alt-name pypi.org \
		--sub-alt-name dl.k8s.io

help: ## Display this help information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
