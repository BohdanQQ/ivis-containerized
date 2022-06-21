FROM ubuntu:18.04
WORKDIR /usr/src/
RUN apt-get update; apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update; \
	apt-get install -y --no-install-recommends \
    nodejs \
    #redis \
    pwgen \
    g++ make bzip2  \
    openjdk-8-jre \
    git \
    libatk-bridge2.0 \
    libgtk-3-0 
RUN apt-get install -y --no-install-recommends git python3 python3-pip python3-venv
RUN git clone https://github.com/smartarch/ivis-core.git
WORKDIR /usr/src/ivis-core
RUN python3 -m pip install --user --upgrade setuptools wheel
RUN cd /usr/src/ivis-core/server/lib/tasks/python/ivis && python3 setup.py sdist bdist_wheel
WORKDIR /usr/src/ivis-core
COPY ./docker-install.sh ./docker-install.sh
COPY ./functions ./functions
RUN /bin/bash ./docker-install.sh 
CMD ["node", "server/index.js"]
EXPOSE 8080
EXPOSE 8081