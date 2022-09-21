#!/bin/bash

run() {
    # Run the compilation process.
    cd $PLATFORM_CACHE_DIR || exit 1;

    if [ ! -f "${PLATFORM_CACHE_DIR}/phalcon/ext/modules/phalcon.so" ]; then
        ensure_source
        checkout_version "$1"
        compile_source
    fi

    copy_lib
    enable_lib
}

enable_lib() {
    # Tell PHP to enable the extensions.
    echo "Enabling PSR extension."
    echo -e "\nextension=${PLATFORM_APP_DIR}/psr.so" >> $PLATFORM_APP_DIR/php.ini
    echo "Enabling Phalcon extension."
    echo -e "\nextension=${PLATFORM_APP_DIR}/phalcon.so" >> $PLATFORM_APP_DIR/php.ini
}

copy_lib() {
    # Copy the compiled library to the application directory.
    echo "Installing Phalcon extension."
    cp $PLATFORM_CACHE_DIR/phalcon/ext/modules/phalcon.so $PLATFORM_APP_DIR
    echo "Installing PSR extension."
    cp $PLATFORM_CACHE_DIR/php-psr/modules/psr.so $PLATFORM_APP_DIR
}

checkout_version () {
    # Check out the specific Git tag that we want to build.
    #git checkout "$1"
    git checkout "tags/v$1" ./
}

ensure_source() {
    # Ensure that the Zephyr is ready and extension source code is available and up to date.
    curl -L https://github.com/zephir-lang/zephir/releases/download/0.16.3/zephir.phar -O
    mv zephir.phar zephir
    chmod a+x zephir
    ls -lth

    # PSR
    git clone https://github.com/jbboehr/php-psr.git
    cd php-psr
    echo "IN PSR dir: "; pwd
    phpize
    ./configure
    make
    make test
    ls -lth
    # go back 
    cd ..

    # Ensure that the extension source code is available and up to date.
    if [ -d "phalcon" ]; then
        cd phalcon || exit 1;
        git fetch --all --prune
    else
	git clone https://github.com/phalcon/cphalcon phalcon
        cd phalcon || exit 1;
    fi
}

compile_source() {
    # Compile the extension.
    echo "I am here: "; pwd
    ../zephir fullclean
    ../zephir compile
    #find . -type f -iname '*ext*'
    cd ext
    echo "I am EXT: "; pwd
    #echo "Copy psr to phalcon ext dir"
    #cp /mnt/cache/app/php-psr/modules/psr.so /mnt/cache/app/phalcon/ext/include/.
    phpize
    ./configure
    make
    # check if phalcon.so now exists 
    ls -lth

}

ensure_environment() {
    # If not running in a Platform.sh build environment, do nothing.
    if [ -z "${PLATFORM_CACHE_DIR}" ]; then
        echo "Not running in a Platform.sh build environment.  Aborting Phalcon installation."
        exit 0;
    fi
}

ensure_arguments() {
    # If no version was specified, don't try to guess.
    if [ -z $1 ]; then
        echo "No version of the PhpPhalcon extension specified.  You must specify a tagged version on the command line."
        exit 1;
    fi
}

ensure_environment
ensure_arguments "$1"
run "$1"
