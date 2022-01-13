# Ali-Bey Docker
Dockerized version of the [Ali-bey georeferencing database](https://github.com/aescobarr/mcnb-alibey).

## General structure

In the docker-compose.yml file, we define the following services:

* web - The main container, it runs the django app through a gunicorn server
* db - The database container. It hosts a PostgreSQL instance with all the app data.
* nginx - The web server. It proxies all traffic back and forth to the gunicorn instance, also serves the django static resources.
* geoserver - A Web Map Service container, which runs a [GeoServer](http://geoserver.org) instance inside a [Tomcat](https://tomcat.apache.org) container

Also, the following volumes:

* static-volume - A volume containing all the django static resources
* geoserver-data-dir - A volume containing the GeoServer data directory
* postgres-data - A volume which contains all the PostgreSQL data files

## Getting Started

These instructions will help you set up this project on a Linux system. It assumes [Git](https://git-scm.com/) is installed in the host machine.

### Prerequisites

The host machine needs a running [Docker](https://docs.docker.com/get-docker/) engine. This version of Ali-Bey has been tested on Docker v20.10.2.

### Installing

First, create a fresh clone of the repository:

```bash
cd ~/tmp
git clone https://github.com/aescobarr/mcnb-alibey-docker.git
cd mcnb-alibey-docker/
```
The app part of the docker images is included in this project via a Git submodule which points to the adequate branch of the [Ali-Bey app](https://github.com/aescobarr/mcnb-alibey). To initialize the submodule, execute the following commands:

```bash
git submodule init
git submodule update
```

### Configuration

All configuration parameters are taken from an .env file in the project root. You can rename the included file dot-env-example as follows:

```bash
mv dot-env-example .env
```

And adjust the following values:

```bash
# This key tells django to run in debug mode (1) or not (0)
# Don't run django with DEBUG=1 in production environments!
DEBUG=1
# Long, complicated string that django uses internally for things like identifying sessions. Keep it unique.
SECRET_KEY=foo
# Hosts which will be allowed to connect to Django
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 [::1]

# Admin user credentials. This user will be created when the container is initialized and you will 
# be able to use it for administrative purposes
DJANGO_ADMIN_USER=alibey_admin
DJANGO_ADMIN_PASSWORD=XXXXXXXXXXX
DJANGO_ADMIN_EMAIL=alibey_admin@alibey.org

# Regular user credentials. This user also is created when the container is initialized.
DJANGO_REGULAR_USER=alibey_regular
DJANGO_REGULAR_PASSWORD=YYYYYYYYYY
DJANGO_REGULAR_EMAIL=alibey_regular@alibey.org

# Django database engine. Do not change this value
SQL_ENGINE=django.contrib.gis.db.backends.postgis
# Name of the app database
SQL_DATABASE=djangoref
# Name of the app database owner user (postgres user)
SQL_USER=aplicacio_georef
# The password of the database owner user
SQL_PASSWORD=ZZZZZZZZZZ
# DB host address. Do not change this value.
SQL_HOST=db
# Database running port
SQL_PORT=5432

# Tomcat admin user
TOMCAT_USER=admintom
# Tomcat admin password
TOMCAT_PASSWORD=TTTTTTTTTTTT
# Tomcat home
TOMCAT_DIR=/usr/local/tomcat
# Geoserver data dir
GEOSERVER_DATA_DIR=/opt/geoserver/data_dir
# Geoserver admin user name
GEOSERVER_ADMIN_USER=admin
# Geoserver admin user password
GEOSERVER_ADMIN_PASSWORD=VVVVVVVVVVVVVVV
# Bing maps API key. If you don't have one, Bing Maps will not work
BING_MAPS_API_KEY='my_bings_api_key'
```


Finally, the remaining thing to do is build the docker images:

```bash
docker-compose build
```

And run them:

```bash
docker-compose up
```

This should build and start all the containers from the images. The app is exposed via the following address:

```bash
http:127.0.0.1:1337
```

