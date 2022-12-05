FROM ubuntu:22.04

ARG SSH_PUB_KEY

RUN apt-get update
RUN apt-get install -y git openssh-server
RUN apt-get install -y maven

RUN useradd -m jenkins
ENV NODE_SSH_DIR=/home/jenkins/.ssh

RUN mkdir $NODE_SSH_DIR
RUN echo $SSH_PUB_KEY > $NODE_SSH_DIR/authorized_keys
RUN chown -R jenkins $NODE_SSH_DIR

RUN service ssh start
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]