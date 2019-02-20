FROM alpine:3.9
 
ENV ANSIBLE_VERSION 2.7.6

ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
 
ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  rsync \
  sshpass \
  git \
  python \
  py-boto \
  py-paramiko \
  py-pip \
  ca-certificates
 
RUN set -ex && \
    apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python-dev && \
    apk update && apk upgrade && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    pip install --upgrade pip && \
    pip install PyYAML openshift ansible==${ANSIBLE_VERSION} && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts
 
WORKDIR /ansible/playbooks
ENTRYPOINT ["ansible-playbook"]
