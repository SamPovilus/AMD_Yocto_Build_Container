FROM ubuntu:24.04

# Install required packages for Yocto builds
USER root
RUN whoami && id && ls -ld /var/lib/apt/lists
RUN apt-get update && apt-get install -y \
build-essential \
chrpath \
cpio \
debianutils \
diffstat \
    file \
    gawk \
    gcc \
    git \
        iputils-ping \
        libacl1 \
        liblz4-tool \
        locales \
            python3  \
            python3-git \
            python3-jinja2 \
            python3-pexpect \
            python3-pip \
                python3-subunit \
                socat  \
                texinfo \
                unzip \
                wget \
                    xz-utils  \
zstd \
    build-essential \
    chrpath \
    diffstat \
    gawk \
    git \
    libncurses5-dev \
    libssl-dev \
    python3 \
    python3-pip \
    python3-pexpect \
    socat \
    texinfo \
    unzip \
    wget \
    xz-utils \
    zlib1g-dev \
    locales \
    cpio \
    file \
    zstd \
    liblz4-tool \
    sudo \
    kconfig-frontends \
    x11-utils \
    xvfb \
    && apt-get clean

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create a user with the same UID and GID as the host user
ARG USERNAME=spovilus
ARG USER_UID=1000
ARG USER_GID=1000
RUN if id -u $USER_UID >/dev/null 2>&1; then \
        EXISTING_USER=$(getent passwd $USER_UID | cut -d: -f1); \
        usermod -l $USERNAME -d /home/$USERNAME -m $EXISTING_USER && \
        groupmod -n $USERNAME $(getent group $USER_GID | cut -d: -f1); \
    else \
        if ! getent group $USER_GID; then groupadd --gid $USER_GID $USERNAME; fi && \
        useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure bash history
RUN echo "export HISTFILE=/home/$USERNAME/.bash_history" >> /home/$USERNAME/.bashrc && \
    echo "export HISTSIZE=10000" >> /home/$USERNAME/.bashrc && \
    echo "export HISTFILESIZE=20000" >> /home/$USERNAME/.bashrc && \
    touch /home/$USERNAME/.bash_history && \
    chown $USER_UID:$USER_GID /home/$USERNAME/.bash_history

# Switch to the created or modified user
USER $USERNAME
WORKDIR /home/$USERNAME

# Ensure bash is the default shell
SHELL ["/bin/bash", "-c"]

# Source .bashrc on container start
CMD ["bash", "--login"]