FROM ventx/alpine:3.6

ENV KUBE_LATEST_VERSION="v1.10.3"
ENV KUBE_RUNNING_VERSION="v1.9.3"
ENV HELM_VERSION="v2.11.0"
ENV AWSCLI 1.16.20

RUN  apk --update add git openssh-client curl python py-pip bash python gettext postgresql-client vim xmlstarlet \
  gcc g++ make python-dev libxml2-dev py-libxml2 py-libxslt libxml2-utils libxml2-dev libxslt-dev \
  && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_RUNNING_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl_latest \
  && chmod +x /usr/local/bin/kubectl_latest \ 
  && wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm 
RUN pip install --upgrade pip \
  && pip install lxml selenium requests allure-pytest pytest-allure-adaptor \
  && pip install awscli==${AWSCLI} 
 
WORKDIR /work

