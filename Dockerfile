#
# LinuxGSM Base Dockerfile
#
# https://github.com/GameServerManagers/LinuxGSM-Docker
#

FROM ubuntu:20.04

LABEL maintainer="LinuxGSM <me@danielgibbs.co.uk>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install UTF-8 unicode
RUN echo "**** Install UTF-8 ****" \
    && apt-get update \
    && apt-get install -y locales apt-utils debconf-utils
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

## Upgrade Ubuntu
RUN echo "**** apt upgrade ****" \
    && apt-get update; \
    apt-get upgrade -y

ARG MINECRAFT_JAVA_PACKAGE=

## Install Base LinuxGSM Requirements
RUN echo "**** Install Base LinuxGSM Requirements ****" \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository multiverse \
    && apt-get update \
    && apt-get install -y \
    $MINECRAFT_JAVA_PACKAGE \
    bc \
    binutils \
    bsdmainutils \
    bzip2 \
    ca-certificates \
	cron \
    cpio \
    curl \
    distro-info \
    file \
    gzip \
    hostname \
    jq \
    lib32gcc1 \
    lib32stdc++6 \
    netcat \
    python3 \
    tar \
    tmux \
    unzip \
    util-linux \
    wget \
    xz-utils \
    # Docker Extras
    cron \
    iproute2 \
    iputils-ping \
    nano \
    vim \
    sudo \
    tini

# Install Cleanup
RUN echo "**** Cleanup ****"  \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

##Need use xterm for LinuxGSM##

ENV DEBIAN_FRONTEND noninteractive

ARG USERNAME=linuxgsm
ARG USER_UID=1000
ARG USER_GID=$USER_UID

## Add linuxgsm user
RUN echo "**** Add linuxgsm user ****" \
# Create the user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chown $USERNAME:$USERNAME /home/$USERNAME

# Create /opt/linuxgsm
#RUN echo "**** Create /opt/linuxgsm ****" \
#    && mkdir -p /opt/linuxgsm \
#    && chown linuxgsm:linuxgsm /opt/linuxgsm

## Download linuxgsm.sh
RUN echo "**** Download linuxgsm.sh ****" \
    && set -ex \
    && wget -O linuxgsm.sh https://linuxgsm.sh \
    && chmod +x /linuxgsm.sh
    
ENV PATH=$PATH:/home/$USERNAME
WORKDIR /home/$USERNAME

COPY entrypoint.sh ./
RUN chown $USERNAME:$USERNAME ./entrypoint.sh
RUN chmod 777 ./entrypoint.sh

USER $USERNAME

# Add LinuxGSM cronjobs
RUN (crontab -l 2>/dev/null; echo "*/5 * * * * /home/$USERNAME/*server monitor > /dev/null 2>&1") | crontab -
RUN (crontab -l 2>/dev/null; echo "*/30 * * * * /home/$USERNAME/*server update > /dev/null 2>&1") | crontab -
RUN (crontab -l 2>/dev/null; echo "0 1 * * 0 /home/$USERNAME/*server update-lgsm > /dev/null 2>&1") | crontab -

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "bash", "./entrypoint.sh" ]
