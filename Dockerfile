# Start from an official Ubuntu image
FROM ubuntu:latest

# Set the working directory to /app
WORKDIR /app

# Define build arguments
ARG container_name=expdev
ARG hostname=ubuntu

# Set environment variables
ENV CONTAINER_NAME $container_name
ENV HOSTNAME $hostname

# Update package manager and install necessary packages
RUN apt-get update && apt-get install -y \
  build-essential \
  gdb \
  python2 \
  python3 \
  python3-pip \
  wget \
  git \
  vim \
  fish \
  tmux \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/the-root-user/dotfiles-and-other-configs/main/tmux.conf -O ~/.tmux.conf
RUN chsh -s /usr/bin/fish
# since gets interpreted by /bin/sh, -e only makes things worse
RUN echo "set number\nsyntax on\ncolorscheme peachpuff\nset cursorline\nset tabstop=4\nset expandtab\nset autoindent\nset nobackup\nset ignorecase\nset showmode" >> ~/.vimrc 

# Install additional Python packages
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install \
  pwntools \
  capstone \
  unicorn \
  ropper \
  patchelf

# Install additional tools
RUN git clone https://github.com/pwndbg/pwndbg.git ~/.pwndbg
RUN cd ~/.pwndbg && ./setup.sh
#RUN echo "source ~/.pwndbg/gdbinit.py" >> ~/.gdbinit
RUN wget https://github.com/io12/pwninit/releases/download/3.3.0/pwninit -O /usr/bin/pwninit && chmod +x /usr/bin/pwninit

# Expose port 22 for ssh
EXPOSE 22

# Run bash when the container launches
CMD ["tmux"] 

# Build
# docker build -t expdev .