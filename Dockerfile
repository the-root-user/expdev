# Start from Ubuntu 22.04 LTS (Jammy) for stability and native Python 2 / 3 support
FROM ubuntu:22.04

WORKDIR /app

# Build arguments
ARG container_name=expdev
ARG hostname=ubuntu

# Environment variables
ENV CONTAINER_NAME=$container_name \
    HOSTNAME=$hostname \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=Asia/Karachi \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

# Configure timezone and install system packages
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y --no-install-recommends \
    locales \
    build-essential \
    python2 \
    python2-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    wget \
    curl \
    git \
    vim \
    fish \
    tmux \
    gdb \
    strace \
    ltrace \
    socat \
    netcat-traditional \
    net-tools \
    iproute2 \
    procps \
    file \
    binutils \
    nasm \
    ca-certificates \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Shell and editor configuration
RUN wget -q https://raw.githubusercontent.com/the-root-user/dotfiles-and-other-configs/main/tmux.conf -O ~/.tmux.conf && \
    chsh -s /usr/bin/fish && \
    printf "set number\nsyntax on\ncolorscheme peachpuff\nset cursorline\nset tabstop=4\nset expandtab\nset autoindent\nset nobackup\nset ignorecase\nset showmode\n" >> ~/.vimrc && \
    mkdir -p ~/.config/fish/ && \
    printf "alias l='ls -CF'\nalias la='ls -A'\nalias lla='l -al'\nalias aslr_check='cat /proc/sys/kernel/randomize_va_space'\n" >> ~/.config/fish/config.fish

# Python exploit development packages
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir \
    pwntools \
    ropper \
    patchelf \
    capstone \
    unicorn

# pwndbg and pwninit
RUN git clone --depth 1 https://github.com/pwndbg/pwndbg.git ~/.pwndbg && \
    cd ~/.pwndbg && \
    sed -i "s/sudo //g" ./setup.sh && \
    ./setup.sh && \
    rm -rf /var/lib/apt/lists/*
RUN wget -q https://github.com/io12/pwninit/releases/download/3.3.0/pwninit -O /usr/bin/pwninit && \
    chmod +x /usr/bin/pwninit

# Expose port 22 for ssh if needed
EXPOSE 22

# Launch tmux with fish shell by default
CMD ["tmux"]
