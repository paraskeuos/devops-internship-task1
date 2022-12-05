FROM ubuntu:22.04

ARG SSH_PUB_KEY

RUN apt-get update 
RUN apt-get install -y curl sudo git openssh-server openjdk-11-jre

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN useradd -m -s /bin/bash jenkins
ENV NODE_SSH_DIR=/home/jenkins/.ssh

RUN mkdir $NODE_SSH_DIR
RUN echo $SSH_PUB_KEY > $NODE_SSH_DIR/authorized_keys
RUN chown -R jenkins $NODE_SSH_DIR

RUN service ssh start
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]