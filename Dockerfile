FROM ubuntu:18.04

ENV USER dev
ENV GROUP dev
ENV UID 1001
ENV GID 1001
ENV TZ Asia/Jakarta

RUN apt-get update && apt-get upgrade -y && apt-get install -y apt-transport-https apt-utils gnupg gnupg2 curl openssh-server mysql-client rsync screen
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl
RUN useradd -m --password $(openssl passwd -1 Pesen14045_#) ${USER} -s /bin/bash \
    && mkdir -p /home/${USER}/.kube \
    && touch /var/log/auth.log

RUN chown -R ${USER}:${GROUP} /home/${USER}/.kube

CMD service ssh start && tail -f /var/log/auth.log
EXPOSE 22
