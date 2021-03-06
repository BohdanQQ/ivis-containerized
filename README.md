# Containerized IVIS-core

Creates a containerized environment for an IVIS-core instance:

* MySQL database with optional Adminer web interface
* Elasticsearch with optional Kibana web interface
* IVIS-core instance configured to use the other containers
* all behind an HTTP(S) Apache proxy

## Full setup - trusted certificates

Clone your IVIS repo

    git clone <YOUR_IVIS_REPO>
    cd ivis-core
    git checkout <YOUR_IVIS_BRANCH>

Note that not every branch / fork might be compatible with the following!

Generate certificates (still in `ivis-core` directory)

    cd ./server/certs/remote/
    ./init.sh
    ./server_cert_gen.sh server <ivis> <sbox> <api>

`ivis`, `sbox` and `api` are the registered A/CNAME DNS records for the trusted, sandbox and api endpoints respectively.

Modify the `docker-compose.yml` to properly mount all required certificates. Please note that both the Apache proxy and IVIS-core need the generated certififcates. Furthermore, modify `docker-compose.yml`, `config/ivis/default.yaml` and `config/apache/vhosts.conf` (or even `apache.conf`) to configure the ports on which you want everything to listen and set proper `ServerName`, `trusted/sandboxUrlBase` values. Do not forget about the database password from `docker-compose.yml` and the secret used for session signing when editing the IVIS-core config. 

Please be careful when modifying the files. They should work out of the box with some minor adjustments (mainly due to domain name differences). As a rule of thumb:
* data in `vhosts.conf` regards the **container network** (apart from the `ServerName` directives) and DNS names used in this file are drawn from the `docker-compose.yml` container names  
* data in `default.yml` regards the **container network** (apart from the `trusted/sandboxUrlBase` entries)

Finally,

    docker compose up --build

The IVIS-Core container will time out several times before actually running with error ` wait-for-it.sh: timeout occurred after ...`. Just wait until the elasticsearch/database container is ready to make connections and IVIS-core will start.

## Local setup - suitable only for a docker network, development

Modify your `/etc/hosts` file (or Windows equivalent) to include three new hosts (for example: `ivis.apache`, `sbox.apache`, `api.apache`) and map them onto the loopback (`127.0.0.1`).

Clone your IVIS repo

    git clone <YOUR_IVIS_REPO>
    cd ivis-core
    git checkout <YOUR_IVIS_BRANCH>

Note that not every branch / fork might be compatible with the following!

Generate certificates (still in `ivis-core` directory)

    cd ./server/certs/remote/
    ./init.sh
    ./server_cert_gen.sh server <ivis> <sbox> <api>

`ivis`, `sbox` and `api` are the hosts you've created in the first step.

Modify the `docker-compose-dev.yml` to properly mount all required certificates and set db password. Please note that both the Apache proxy and IVIS-core need the generated certififcates. Furthermore, modify `docker-compose-dev.yml`, `config/ivis/default.yaml` and `config/apache/vhosts.conf` (or even `apache.conf`) to configure the ports on which you want everything to listen and set proper `ServerName`, `trusted/sandboxUrlBase` values. Do not forget about the database password from `docker-compose.yml` and the secret used for session signing when editing the IVIS-core config. 

In addition to that, uncomment the `tapache.networks.aliases` section in `docker-compose-dev.yml` and set the aliases to the hosts you've created.

* **IMPORTANT**: to make this a truly local instance (in case you're exposed to the internet), replace all port exposure from `1234:5678` to (quoted!) `"127.0.0.1:1234:5678"`

Please be careful when modifying the files. They should work out of the box with some minor adjustments (mainly due to domain name differences). As a rule of thumb:
* data in `vhosts.conf` regards the **container network** (apart from the `ServerName` directives) and DNS names used in this file are drawn from the `docker-compose-dev.yml` container names  
* data in `default.yml` regards the **container network** (apart from the `trusted/sandboxUrlBase` entries)

Finally,

    docker compose -f ./docker-compose-dev.yml up --build


To prevent client rebuilding when not needed, use just

    docker compose -f ./docker-compose-dev.yml up
On the other hand, to force a rebuild, use the `--build` switch.

To rebuild the IVIS python package, the IVIS container must be restarted as the package build is part of the entrypoint script.

Please expect that your browser will panic about the certificates being invalid. Either ignore this or inject the local CA from `ivis-core/server/remote/ca` into your browser. 

### Simulating a "remote" executor

Adding a remote executor requires attaching the executor to the same network. 

All configuration (both executor config and the executor database entries on IVIS-core) is done with respect to the **container network**. E.g. you use the container names as defined in the `docker-compose` files (or their network aliases) and ports facing into the container network, not the host network! The executor thus does not need to expose any ports to the host network.

## Reasoning

### Local setup still uses certificates

This is due to the remote executor simulation. Certificates are still needed to access the remote executor and there would be close to no point in simulating the executor if the main security feature was not even present.

### Apache vs Nginx

Though Nginx seems to provide more friendly configuration (especially with non-standard Apache Docker container paths), it proved useless in the implementation of the `rest/remote/` endpoint.

This endpoint is used from the Internet by remote executors to communicate job status / perform special requests and thus must be secured by veryfiying the client. Nginx simply does not support client certificate renegotiation based on the URI location (`rest/remote/*` in this case) while Apache supports it.