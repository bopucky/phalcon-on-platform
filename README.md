# phalcon-on-platform
- Compile phalcon from source on Platform.sh using the custom script install-phpphalcon.sh
- Instructions to compile phalcom from source are https://docs.phalcon.io/4.0/en/installation#installation
- PSR extension is also compiled since phalcon requires it. Obtained from https://github.com/jbboehr/php-psr
- Zephir is downloaded as a requirement as well. Obtained from https://github.com/zephir-lang/zephir/releases
- Compilation is triggered from the build hook in .platform.app.yaml with:
```
    build: |
        set -e
        # Install phalcon v4.0.0:
        { bash install-phpphalcon.sh 4.0.0 ; } 3<&0
```
These instructions assume that install-phpphalcon.sh has been committed to the repository. 
You can do something different if you wish. This is a proof of concept after all, so expect sharp edges, and refine as desired.
