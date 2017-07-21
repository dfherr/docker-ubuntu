FROM       ubuntu:16.04
MAINTAINER Dennis-Florian Herr <herrdeflo@gmail.com>

# ubuntu setup

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq -y; \
    apt-get install --assume-yes apt-utils; \
    apt-get install --no-install-recommends -y \
    sudo \
    curl \
    iputils-ping \
    build-essential \
    autoconf \
    apt-transport-https \
    git \
    vim \
    locales \
    tzdata; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/cache/apt/*;

RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN locale-gen en_US.UTF-8
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8" LC_CTYPE="en_US.UTF-8"

RUN useradd -m -s /bin/bash ubuntu; \
    chgrp -R ubuntu /usr/local; \
    find /usr/local -type d | xargs chmod g+w; \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ubuntu; \
    chmod 0440 /etc/sudoers.d/ubuntu


ADD bin/dumb-init_1.2.0 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENV DUMB_INIT_SETSID="0" HOME=""/home/ubuntu"

WORKDIR    /home/ubuntu
USER       ubuntu
ADD config/.vimrc /home/ubuntu/.vimrc
ENTRYPOINT ["dumb-init"]
