FROM ubuntu:focal

ENV container docker
ENV DEBIAN_FRONTEND noninteractive

# Unminimize (add documentation, tools, ...)
RUN yes | unminimize

# Install locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
      locales && \
    echo "$LANG UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install systemd
RUN apt-get update && apt-get install -y \
      dbus dbus-x11 systemd && \
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    dpkg-divert --local --rename --add /sbin/udevadm &&\
    ln -s /bin/true /sbin/udevadm

# Install GNOME
RUN apt-get update && apt-get install -y \
      unity && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install sudo
RUN apt-get update && apt-get install -y \
      sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
#   Syntax: User Host = (Runas) Command (https://toroid.org/sudoers-syntax)
#     User: ALL, user, %group, #uid, %#gid
RUN echo "default ALL=(ALL) NOPASSWD: ALL" >> "/etc/sudoers"

# Allow system user creation by everyone
RUN chmod 666 /etc/passwd /etc/group /etc/shadow
COPY generate_container_user /

# Setup entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

