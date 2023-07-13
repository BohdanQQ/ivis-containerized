FROM centos:7
WORKDIR /opt
RUN yum update -y
RUN yum install -y epel-release
RUN curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
RUN yum install -y install \
    nodejs \
    #redis \
    pwgen \
    gcc-c++ make bzip2  \
    java-1.8.0-openjdk \
    git \
    libXScrnSaver \
    at-spi2-atk \
    gtk3 
RUN npm install -g nodemon npm-run-all
RUN yum install -y git python3 python3-pip openssl
RUN python3 -m pip install --user --upgrade setuptools wheel
# ------------------------------------ rebuild modules

WORKDIR /opt/ivis-core/embedding
COPY ./ivis-core/embedding/package*.json ./
RUN echo "building embedding packages"
RUN npm install --unsafe-perm

WORKDIR /opt/ivis-core/shared
COPY ./ivis-core/shared/package*.json ./
RUN echo "building shared packages"
RUN npm install --unsafe-perm

WORKDIR /opt/ivis-core/client
COPY ./ivis-core/client/package*.json ./
RUN echo "building client packages"
RUN npm install --unsafe-perm

WORKDIR /opt/ivis-core/server
COPY ./ivis-core/server/package*.json ./
RUN echo "building server packages"
RUN npm install --unsafe-perm

WORKDIR /opt/ivis-core/client
# copy things necessary to build the client
# this build step is the last one in order to allow caching to mitigate
# most of the build time in case the client is changed and needs a rebuild
COPY ./ivis-core/client/ ./
COPY ./ivis-core/locales/ ../locales
COPY ./ivis-core/shared/ /opt/ivis-core/shared
RUN npm run build


WORKDIR /opt/ivis-core/
COPY ./ivis-core ./

WORKDIR /opt/ivis-core/server/lib/tasks/python/ivis
RUN python3 setup.py sdist bdist_wheel

EXPOSE 8080 8081 8082

WORKDIR /opt/ivis-core
COPY ./docker-entry.sh ./docker-entry.sh
COPY ./wait-for-it.sh ./wait-for-it.sh
ENTRYPOINT [ "bash", "/opt/ivis-core/docker-entry.sh" ]