# Start from an official Ubuntu image
FROM ubuntu:latest

WORKDIR /app

# Build arguments
ARG container_name=expdev
ARG hostname=ubuntu

# Environment variables
ENV CONTAINER_NAME $container_name
ENV HOSTNAME $hostname
ENV LANG en_US.utf8
ENV TZ=Asia/Karachi

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    locales build-essential \
    python2 python3 python3-pip \
    wget git vim fish tmux \
    gdb strace ltrace && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    apt-get update

RUN wget https://raw.githubusercontent.com/the-root-user/dotfiles-and-other-configs/main/tmux.conf -O ~/.tmux.conf; \
    chsh -s /usr/bin/fish; \
    # since gets interpreted by /bin/sh, -e only makes things worse
    echo "set number\nsyntax on\ncolorscheme peachpuff\nset cursorline\nset tabstop=4\nset expandtab\nset autoindent\nset nobackup\nset ignorecase\nset showmode" >> ~/.vimrc; \
    echo "alias l='ls -CF'\nalias la='ls -A'\nalias lla='l -al'\nalias aslr_check='cat /proc/sys/kernel/randomize_va_space'" >> ~/.config/fish/config.fish
    # docker container cannot overwrite kernel stuff
    
# Additional Python packages
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install \
    pwntools ropper patchelf \
    capstone unicorn

# Additional tools
RUN git clone https://github.com/pwndbg/pwndbg.git ~/.pwndbg && cd ~/.pwndbg && \
    DEBIAN_FRONTEND=noninteractive ./setup.sh
    # RUN echo "source ~/.pwndbg/gdbinit.py" >> ~/.gdbinit
RUN wget https://github.com/io12/pwninit/releases/download/3.3.0/pwninit -O /usr/bin/pwninit && chmod +x /usr/bin/pwninit

# Expose port 22 for ssh
EXPOSE 22

# Run (not bash but) tmux when the container launches
CMD ["tmux"]