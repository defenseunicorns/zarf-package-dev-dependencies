# zarf-package-dev-dependencies

An example / experiment on how to include development dependencies inside of a Zarf package.

To deploy this package you must specify a TLS certificate and key that matches the upstream web hosts used by this package (github.com)

To create this, copy `zarf-config.example.toml` to `zarf-config.toml` and run the following commands:

```shell
openssl req -newkey rsa:2048 -nodes -keyout tls.key -x509 -days 365 -out tls.crt # Common Name MUST be github.com
# cat tls.ca | base64 # set tls_ca to this value in zarf-redirector/zarf.yaml (removing new lines)
cat tls.crt | base64 # set tls_crt to this value in zarf-redirector/zarf.yaml (removing new lines)
cat tls.key | base64 # set tls_key to this value in zarf-redirector/zarf.yaml (removing new lines)
```

# building the docker container

To locally build the docker container in this repo, run: 

```shell
docker build .
```

π
