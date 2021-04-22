FROM bitnami/minideb

ENV RUNNER_NAME "terragrunt-github-runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"


RUN apt-get update \
  && apt-get install -y git wget curl unzip pass gpg sudo jq iputils-ping \
    apt-transport-https ca-certificates gnupg-agent software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m github \
  && usermod -aG sudo github \
  && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


USER github
WORKDIR /home/github

RUN GITHUB_RUNNER_VERSION=$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | jq -r '.tag_name[1:]') \
    && curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz \
    && sudo ./bin/installdependencies.sh

COPY --chown=github:github entrypoint.sh runsvc.sh ./
RUN sudo chmod u+x ./entrypoint.sh ./runsvc.sh

RUN git clone -q https://github.com/cunymatthieu/tgenv.git /home/github/.tgenv
RUN git clone -q https://github.com/tfutils/tfenv.git /home/github/.tfenv
RUN wget -q -O /home/github/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v6.3.1/aws-vault-linux-amd64 \
	&& chmod +x /home/github/bin/*

ENV PATH /home/github/.tgenv/bin:/home/github/.tfenv/bin:/home/github/bin:/usr/bin:$PATH
ENV HOME /home/github

RUN tgenv install 0.28.4
RUN tfenv install 0.13.5

RUN  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && sudo ./aws/install \
  && rm -f awscliv2.zip

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
  && sudo mv /tmp/eksctl /usr/local/bin

ENTRYPOINT ["/home/github/entrypoint.sh"]
