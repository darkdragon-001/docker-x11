FROM ubuntu:xenial

ENV container docker
ENV DEBIAN_FRONTEND noninteractive

# Install locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales && \
    echo "$LANG UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install systemd
RUN apt-get update && apt-get install -y \
    dbus dbus-x11 systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* &&\
    dpkg-divert --local --rename --add /sbin/udevadm &&\
    ln -s /bin/true /sbin/udevadm

# Install Unity
RUN apt-get update \
  && apt-get install -y unity \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create unprivileged user (user and group names are "default")
ENV HOME=/home/default
WORKDIR $HOME
# Install sudo
RUN apt-get update && apt-get install -y sudo && apt-get clean && rm -rf /var/lib/apt/lists/*
# Setup sudo
#   Allow group "default" to use sudo without password
#   Alternative use keyword "ALL" to match all users/groups
RUN echo "%default ALL=(ALL) NOPASSWD: ALL" >> "/etc/sudoers"
# Use libnss_switch to "create" user
#   Install NSS
RUN apt-get update && apt-get install -y libnss-wrapper && apt-get clean && rm -rf /var/lib/apt/lists/*
#   Copy script to generate user and switch to it
COPY generate_container_user /
# Setup entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

