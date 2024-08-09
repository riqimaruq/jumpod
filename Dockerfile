# Use an appropriate base image, such as Ubuntu
FROM ubuntu:latest
ENV USER dev
ENV GROUP dev
ENV UID 1001
ENV GID 1001
ENV TZ Asia/Jakarta
# Install curl and gnupg
RUN apt-get update && apt-get upgrade -y && apt-get install -y apt-transport-https apt-utils gnupg gnupg2 curl openssh-server mysql-client rsync screen

# Create the directory for apt keyrings
RUN mkdir -p -m 755 /etc/apt/keyrings

# Download the public signing key for the Kubernetes package repositories
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes apt repository
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' > /etc/apt/sources.list.d/kubernetes.list

# Adjust permissions for Kubernetes apt repository file
RUN chmod 644 /etc/apt/sources.list.d/kubernetes.list

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Any additional commands or configurations can be added here

# Command to run when the container starts
CMD ["/bin/bash"]

RUN apt-get update
RUN apt-get install -y kubectl
RUN useradd -m --password $(openssl passwd -1 Pesen14045_#) ${USER} -s /bin/bash \
    && mkdir -p /home/${USER}/.kube \
    && touch /var/log/auth.log

ADD kubeconfig /home/${USER}/.kube/config
RUN chown -R ${USER}:${GROUP} /home/${USER}/.kube

CMD service ssh start && tail -f /var/log/auth.log
EXPOSE 22