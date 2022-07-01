# Containerized IVIS-core

Creates a containerized environment for an ivis core instance (for development):

* MariaDB database with Adminer web interface
* Elasticsearch with Kibana web interface
* IVIS-core instance configured to use the other containers
  
So far the IVIS instance is installed WITHOUT the SSL certificate protection!
  * the idea is that there will be an `httpd` container running the reverse proxy required by the installation

To build and run:

    git clone <YOUR_IVIS_REPO>
    cd ivis-core
    git checkout <YOUR_IVIS_BRANCH>
    docker-compose up --build

Note that not every branch / fork might be compatible.

To prevent client rebuilding when not needed, use just

    docker-compose up
On the other hand, to force a rebuild, use the `--build` switch.

To rebuild the ivis python package, the ivis container must be restarted as the package build is part of the entrypoint script.