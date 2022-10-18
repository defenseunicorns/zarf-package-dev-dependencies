# zarf-package-dev-dependencies

An example / experiment on how to include development dependencies inside of a Zarf package.

To deploy this package you must specify a TLS certificate and key that matches the upstream web hosts used by this package (github.com)

To create this, copy `zarf-config.example.toml` to `zarf-config.toml` and run the following commands:

```shell
zarf tools pki github.com
cat tls.crt | base64 # set tls_crt to this value (removing new lines)
cat tls.key | base64 # set tls_key to this value (removing new lines)
```

> *NOTE* this also currently requires the following line in the coredns configmap: `rewrite name github.com agent-redirector.zarf.svc.cluster.local`
