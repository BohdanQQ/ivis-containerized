# Containerized IVIS-core

Creates a containerized environment for an ivis core instance (for development):

* MariaDB database with Adminer web interface
* Elasticsearch with Kibana web interface
* IVIS-core instance configured to use the other containers
  
So far the IVIS instance is installed WITHOUT the SSL certificate protection!

To build and run:

     docker-compose up --build

To force a rebuild (in case IVIS-core should be updated with upstream commits), change `echo "cache-bust"` to `echo "SOMETHING_DIFFERENT"` in the `Dockerfile-centos` file.

