Docker Source-to-image Builder for PHP
======================================

Image for building and injecting PHP applications into a resulting Docker image.

OS          | Server     | PHP 5.3 | PHP 5.4 | PHP 5.5 | PHP 5.6
----------- | ---------- |:-------:|:-------:|:-------:|:-------:
RHEL-7.x    | Apache 2.4 |         |    ✓    |         |         
CentOS-7.x  | Apache 2.4 |         |    ✓    |         |         

**WARNING: Under heavy development. Forking is not recommended.**

Installation
------------

Prerequisites:

1. [Docker](https://docs.docker.com/installation/)
2. [Source-to-image (`sti`)](https://github.com/openshift/source-to-image#installation)

1. CentOS 7.x

    TODO

2. RHEL 7.x

    This image is **not** available as trusted build in the [Docker Hub Registry](https://registry.hub.docker.com/). To build it manually, you need to run the following commands on a properly subscribed RHEL-7.x machine.

    ```
    $ git clone https://github.com/VojtechVitek/php.git && cd php
    $ docker build -t openshift/php:5.4-rhel7-apache .
    ```

Usage
-----

This image is not intended to be invoked by `docker run` command. Instead, it serves as a builder image that picks up a specified PHP application's source code (from a GIT repository) and creates a runnable RHEL-7.x Docker image from it.

```
$ sti build <PHP-SOURCE-CODE> openshift/php:<VERSION>-<OS>-<SERVER> <RESULT-IMAGE-TAG>
```

Example workflow:

1. **Build and inject** the [PHP example app](https://github.com/VojtechVitek/php-example-app)'s source code into a resulting `my-php-app` RHEL-7.x Docker image using the [`sti`](https://github.com/openshift/source-to-image) tool:

    ```
    $ sti build https://github.com/VojtechVitek/php-example-app openshift/php:5.4-rhel7-apache my-php-app
    ```

2. **Run** the resulting RHEL-7.x image via [Docker](https://www.docker.com/):

    ```
    $ docker run -p 8080:80 my-php-app
    ```

3. **Access** the running application:

    ```
    $ curl 127.0.0.1:8080
    ```

TODO: Add workflow using [OpenShift](https://github.com/openshift/origin) Application Platform.

Compatible frameworks
---------------------

Framework name | Compatible versions
-------------- | -------------------
[Laravel](https://github.com/laravel/laravel) | 5.x

Composer
--------

* TODO - [Composer](https://github.com/composer/composer)

PECL
----

* TODO - List of supported PECLs, how to enable/disable


Environment variables
---------------------

| Variable name | Default value | Description |
| ------------- | ------------- | ----------- |
| DOCUMENT_ROOT | '.' | Relative path inside the GIT repository. Specifies the document root directory from which server executes PHP scripts ([`$_SERVER['DOCUMENT_ROOT']`](http://php.net/manual/en/reserved.variables.server.php)). |
| STI_SCRIPTS_URL | '[.sti/bin](.sti/bin)' | Source URL/directory from which *assemble*, *run* and *save-artifacts* scripts are be downloaded/copied from. |

Directory structure
-------------------

* **`.sti/bin/`**

  This directory contains scripts that are run by [STI](https://github.com/openshift/source-to-image):

  *   **`assemble`**

      Is used to restore the build artifacts from the previous built (in case of 'incremental build'), to install the sources into location from where the application will be run and prepare the application for deployment (eg. installing libraries/modules via Composer, PEAR, etc..)

  *   **`run`**

      This script is responsible for running the web server for the application.

  *   **`save-artifacts`**

      In order to do an *incremental build* (iow. re-use the build artifacts
      from an already built image in a new image), this script is responsible for archiving those. In this image, this script will archive all dependent libraries/modules.

* **`test/`**

      TODO

License
-------

Released under the [Apache License, Version 2.0](http://www.apache.org/licenses/).