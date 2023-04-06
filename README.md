# [EXPERIMENTAL] zarf-package-dev-dependencies

![CI Status](https://github.com/defenseunicorns/zarf-package-dev-dependencies/actions/workflows/e2e-test.yaml/badge.svg)

This is a package that demonstrates an example using Zarf in its redirector proxy mode.  This allows you to include development dependencies inside of a Zarf package and serve them in an airgap.

> **Note**: This package and functionality is still in early development and will have rough edges.  This functionality also only supports `npm`, `pypi`, `generic`, and `git` artifacts and repositories.  We also rely heavily on how [Gitea](https://docs.gitea.io/en-us/usage/packages/overview/) and [Gitlab](https://docs.gitlab.com/ee/user/packages/package_registry/) handle package registries.

## creating the package

You need the following installed locally before creating this package:

```shell
zarf
curl
npm
pip
jq
sed
sha1sum
```

Then you simply need to run the following (see the `Makefile` for more information)

```shell
$ make build
```

## deploying the package

You need the following installed/available locally before deploying this package:

```shell
zarf
zarf-init-*.tar.zst
zarf-package-dev-dependencies-amd64.tar.zst
tar
sed
awk
```

Before you begin you must `zarf init` your k8s cluster (including a `git` and `artifact` host):

```shell
$ zarf init --components git-server --confirm
```

> **Note**: You can [configure an external git and/or artifact host](https://docs.zarf.dev/docs/user-guide/the-zarf-cli/cli-commands/zarf_init) if you desire.

You must also specify a TLS certificate and key that matches the upstream web hosts used by this package.

To create this, copy `zarf-config.example.toml` to `zarf-config.toml` and run the following command (see the `Makefile` for more information):

```shell
$ make setup-certificates
```

Then you simply need to run the following (see the `Makefile` for more information)

```
$ zarf package deploy zarf-package-dev-dependencies-amd64.tar.zst
```

> **Note:** If you do not have a kubernetes cluster in your airgap you will need to add the `k3s` component to the commands above

## testing the package

After deploying the package you can test that it can properly deploy and build the code in the `src` directory by running:

```shell
$ ./test/run.sh
```

## building the docker container

To locally build the zarf-uploader docker container in this repo, run: 

```shell
docker build .
```
