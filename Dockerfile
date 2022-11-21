FROM jenkins/ssh-agent:jdk11

USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl unzip && update-ca-certificates
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
WORKDIR /opt
RUN curl -LO https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl https://deb.nodesource.com/setup_current.x | bash && apt-get install -y nodejs
RUN npm i -g npm@latest
RUN npm install -y -g newman
RUN apt-get install -y git-core
COPY ./agent.jar /bin/
RUN chmod 755 /bin/agent.jar
RUN echo "PATH=${PATH}" >> /etc/environment
ENV JENKINS_AGENT_SSH_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCVEl8WNUIqs8VhJiUOu197WVIL8Z414C7sUzJMpwk1J28gYpigVojZTzSJIa9iFztXB3pRMej88JMvkMmZbfvvvXgEc0Sb7lh3qk4yMxYBbNnsPuCiFgCXVUGm1RayH9fpNR+hbmwzOZLTtug1GCWYXFmk6PfQXJDsd5wKFsvySOrTvjXfoJtxLwueDBbGq8nPmt75gtV+C796WMSH3AmnFDBW1fy84qCRMo3AT7ZWyHX4gXSRLFLbRipMAZJpGMAuFIBUhn5ePBmn+JtB0Mi2PQIdEJ+ZIrm8nm7fAJHw3sFaZvbEExQ2/fG33MaHxVzQAIQiDThK+HYEF/p1UCE9asrpuAFl86jidu9+X8/+YBf77dZ+HjyVAm4jx2z6TjZ3v/aXm1Px94k4J4FQYS/NzRRAHMyQBfFdhYVOZ3PecJVsj9FpCIt4wnmyiwXTvF4Fnpmv1bKbNUj51DCCQOw3wPcZo9IlUhP+Chz5hNih3ZGhaZBsDc2bC3z+vG7ikyU= teralco@bootcamp01"
