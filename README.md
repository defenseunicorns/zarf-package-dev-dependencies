# zarf-package-dev-dependencies

An example / experiment on how to include development dependencies inside of a Zarf package.

To deploy this package you must specify a TLS certificate and key that matches the upstream web hosts used by this package.

To create this, copy `zarf-config.example.toml` to `zarf-config.toml` and run the following commands:

```shell
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -config tls-req.conf -sha256
cat tls.crt | base64 | tr -d '\n' # set tls_crt to this value in zarf-config.toml under [package.deploy.set]
cat tls.key | base64 | tr -d '\n' # set tls_key to this value in zarf-config.toml under [package.deploy.set]
```

You will also need the following binaries locally before creating this package:

```shell
zarf
openssl
curl
npm
kubectl
```

# building the docker container

To locally build the docker container in this repo, run: 

```shell
docker build .
```

π
