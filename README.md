# phalcon-on-platform
- Compile phalcon from source on Platform.sh using the custom script install-phalcon.sh
- Instructions to compile phalcom from source are https://docs.phalcon.io/4.0/en/installation#installation
- This works for PHP 7.4 (and maybe 7.x, in general). Check with phalcon docs. Compilation does not work with PHP8.x.
- PSR extension is also compiled since phalcon requires it. Obtained from https://github.com/jbboehr/php-psr
- Zephir is downloaded as a requirement as well. Obtained from https://github.com/zephir-lang/zephir/releases
- Compilation is triggered from the build hook in .platform.app.yaml with:
```
    build: |
        set -e
        # Install phalcon v4.0.0:
        { bash install-phalcon.sh 4.0.0 ; } 3<&0
```
These instructions assume that install-phalcon.sh has been committed to the repository.
You can do something different if you wish. This is a proof of concept, so sharp edges are probable, and refine as desired.
