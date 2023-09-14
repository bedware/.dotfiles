FROM ubuntu:focal
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get install -y build-essential curl git neovim ansible && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get clean autoclean && \
    apt-get autoremove -y
WORKDIR /root
COPY . .

