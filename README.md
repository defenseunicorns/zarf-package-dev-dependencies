# zarf-package-dev-dependencies

![CI Status](https://github.com/defenseunicorns/zarf-package-dev-dependencies/actions/workflows/e2e-test.yml/badge.svg)

An example on how to include development dependencies inside of a Zarf package for serving in an airgap.

## creating the package

You need the following installed locally before creating this package:

```shell
zarf
curl
npm
kubectl
jq
sed
```

Then you simply need to run the following (see the `Makefile` for more information)

```
make build
```

## deploying the package

You need the following installed locally before deploying this package:

```shell
zarf
zarf-init-*.tar.zst
zarf-package-dev-dependencies-amd64.tar.zst
tar
sed
awk
```

To deploy this package you must specify a TLS certificate and key that matches the upstream web hosts used by this package.

To create this, copy `zarf-config.example.toml` to `zarf-config.toml` and run the following command (see the `Makefile` for more information):

```shell
make setup-certificates
```

Then you simply need to run the following (see the `Makefile` for more information)

```
zarf init --components git-server --confirm
zarf package deploy /path/to/built/package/zarf-package-dev-dependencies-amd64.tar.zst
```

> **Note:** If you do not have a kubernetes cluster in your airgap you will need to add the `k3s` component to the commands above

## building the docker container

To locally build the helper docker containers in this repo, run: 

```shell
docker build .
docker build -f Dockerfile.util .
```

π
