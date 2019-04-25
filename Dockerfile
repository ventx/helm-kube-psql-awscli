FROM ventx/alpine:3.6

LABEL maintainer="martin@ventx.de, hajo@ventx.de"

ENV KUBE_LATEST_VERSION v1.13.4
ENV KUBE_RUNNING_VERSION v1.11.6
ENV HELM_VERSION v2.13.1
ENV AWSCLI 1.16.145

RUN apk --update --no-cache add \
  bash \
  curl \
  g++ \
  gcc \
  gettext \
  git \
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
  xmlstarlet \
  tzdata
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_RUNNING_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl_latest \
  && chmod +x /usr/local/bin/kubectl_latest \ 
  && wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm 
RUN pip install --upgrade pip \
  && pip install lxml selenium html requests allure-pytest pytest-allure-adaptor \
  && pip install awscli==${AWSCLI} \
  && pip3 install imbox six requests allure-pytest lxml

ADD https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.7.0/allure-2.7.0.tgz /opt/

RUN tar -xvzf /opt/allure-2.7.0.tgz --directory /opt/ \
    && rm /opt/allure-2.7.0.tgz

ENV TZ Europe/Berlin
ENV PATH="/opt/allure-2.7.0/bin:${PATH}"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 
WORKDIR /work

