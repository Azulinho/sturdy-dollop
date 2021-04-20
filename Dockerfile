FROM bitnami/minideb

RUN apt-get update && apt-get install -y git wget curl unzip pass gpg
#RUN useradd  -g users -s /bin/bash -m -d /home/user user


#USER user
RUN git clone -q https://github.com/cunymatthieu/tgenv.git /root/.tgenv
RUN git clone -q https://github.com/tfutils/tfenv.git /root/.tfenv
RUN mkdir /root/bin && wget -q -O /root/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v6.3.1/aws-vault-linux-amd64 \
	&& chmod +x ~/bin/*

ENV PATH /root/.tgenv/bin:/root/.tfenv/bin:/root/bin:$PATH
ENV HOME /root
WORKDIR /root
RUN mkdir -p .aws \
  && echo "[profile Admin@sandbox1]\nrole_arn=arn:aws:iam::111111111111:role/Sandbox1AdminRole" > .aws/config

RUN tgenv install 0.28.4
RUN tfenv install 0.13.5
