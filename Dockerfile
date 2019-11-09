FROM ventx/alpine:3.6

LABEL maintainer="martin@ventx.de, hajo@ventx.de"

ENV KUBE_LATEST_VERSION v1.16.2
ENV KUBE_RUNNING_VERSION v1.11.6
ENV HELM_VERSION v2.13.1
ENV HELM_DIFF_VERSION="v2.11.0%2B5"
ENV AWSCLI 1.16.277
ENV SOPS_VERSION 3.4.0

ENV HELM_HOME=/usr/local/helm

RUN apk --update --no-cache add \
  bash \
  curl \
  g++ \
  gcc \
  gettext \
  git \
  gnupg \
  libxml2-dev \
  libxml2-utils \
  libxslt-dev \
  make \
  openjdk8-jre \
  openssh-client \
  postgresql-client \
  python \
  python-dev \
  python3 \
  python3-dev \
  py-libxml2 \
  py-libxslt \
  py-pip \
  vim \
  xmlstarlet
  #tzdata
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_RUNNING_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl_latest \
  && chmod +x /usr/local/bin/kubectl_latest \ 
  && wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm \
  && curl -L -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux \
  && chmod +x /usr/local/bin/sops && \
  rm -rf /var/cache/apk/*

RUN pip install --upgrade pip \
  && pip install lxml selenium html requests allure-pytest pytest-allure-adaptor \
  && pip install awscli==${AWSCLI} \
  && pip3 install imbox six requests allure-pytest lxml

ADD https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.7.0/allure-2.7.0.tgz /opt/

RUN tar -xvzf /opt/allure-2.7.0.tgz --directory /opt/ \
    && rm /opt/allure-2.7.0.tgz

RUN helm init --client-only
RUN mkdir -p /usr/local/helm/plugins \
  && wget -c https://github.com/databus23/helm-diff/releases/download/${HELM_DIFF_VERSION}/helm-diff-linux.tgz -O - | tar -C /usr/local/helm/plugins -xzv
RUN helm plugin install https://github.com/futuresimple/helm-secrets

# RUN helm plugin install https://github.com/databus23/helm-diff.git
# RUN helm plugin install https://github.com/futuresimple/helm-secrets.git

RUN helm version --client \
  && helm plugin list

# ENV TZ Europe/Berlin
ENV PATH="/opt/allure-2.7.0/bin:${PATH}"

# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 
WORKDIR /work

