FROM golang:1.14.11-stretch as build

ARG awscli_version

ARG awsu_version

ARG packer_version

ARG shellcheck_version

ENV \
    PACKER_DEV=true

RUN \
    apt-get update -q && apt-get install -qqy \
        cabal-install \
        curl \
        git \
        libpcsclite-dev \
        unzip

WORKDIR /go/src/github.com/kreuzwerker/awsu

RUN \
    git clone --branch="${awsu_version}" --depth=1 \
        'https://github.com/kreuzwerker/awsu.git' \
        . \
    && go mod download \
    && go build -o build/awsu-linux-amd64 awsu.go

WORKDIR /go/src/github.com/koalaman/shellcheck

RUN \
    git clone --branch="v${shellcheck_version}" --depth=1 \
        'https://github.com/koalaman/shellcheck.git' \
        . \
    && cabal update \
    && cabal install

WORKDIR /go/src/amazonaws.com/aws/awscli-exe

RUN \
    curl -fsL \
        "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${awscli_version}.zip" \
        -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip \
    && ./aws/install --install-dir /opt/aws-cli --bin-dir /usr/local/bin/aws-cli

WORKDIR /go/src/github.com/hashicorp/packer

RUN \
    git clone --branch="v${packer_version}" --depth=1 \
        'https://github.com/hashicorp/packer.git' \
        . \
    && make releasebin GOX_PARALLEL_BUILDS=$(nproc)


FROM ubuntu:18.04 as main

ARG common_user=pycharm

ARG docker_version

ARG pycharm_version

ARG tfenv_version

ARG terraform_version

ARG pre_commit_version

ENV \
    AWS_PROFILE='mfa' \
    PYCHARM_VERSION="${pycharm_version}" \
    QT_XKB_CONFIG_ROOT='/usr/share/X11/xkb' \
    XDG_RUNTIME_DIR='/run/user/1000'

WORKDIR /opt/jetbrains

COPY --from=build --chown=root:root \
    /go/src/github.com/kreuzwerker/awsu/build/awsu-linux-amd64 \
    /usr/bin/awsu

COPY --from=build --chown=root:root \
    /go/src/github.com/koalaman/shellcheck/dist/build/shellcheck/shellcheck \
    /usr/bin/

COPY --from=build --chown=root:root \
    /opt/aws-cli \
    /opt/aws-cli

COPY --from=build --chown=root:root \
    /usr/local/bin/aws-cli \
    /usr/local/bin/aws-cli

COPY --from=build --chown=root:root \
    /go/bin/packer \
    /usr/local/bin/packer

RUN \
    export DEBIAN_FRONTEND=noninteractive \
    && apt update -qq \
    && apt install -y -qq \
        build-essential \
        curl \
        direnv \
        git \
        jq \
        libasound2 \
        libapt-pkg-dev \
        libatk-bridge2.0-0 \
        libgbm1 \
        libglu1-mesa \
        libgtk2.0-0 \
        libnss3 \
        libpcsclite-dev \
        libx11-6 \
        libx11-xcb-dev \
        libxss1 \
        libxtst6 \
        python3-dev \
        python3.8 \
        python3.8-dev \
        python3.8-distutils \
        python3.8-venv \
        unzip \
        x11-xserver-utils \
    && python3.8 -m venv /opt/virtualenv \
    && bash -c 'source /opt/virtualenv/bin/activate && pip3 install --upgrade pip && pip3 install pre-commit=='"${pre_commit_version}" \
    && install --directory --mode=0755 /opt/docker /opt/jetbrains \
    && curl -fsL 'https://download.jetbrains.com/python/pycharm-professional-'"${PYCHARM_VERSION}"'.tar.gz' \
        | tar -zxf - -C /opt/jetbrains \
    && curl -fsL 'https://download.docker.com/linux/static/stable/x86_64/docker-'"${docker_version}"'.tgz' \
        | tar -zxf - -C /opt/docker --strip-components=1 \
    && groupadd --gid 999 docker \
    && groupadd --gid 1000 "${common_user}" \
    && useradd \
        --home-dir "/home/${common_user}" \
        --create-home \
        --no-user-group \
        --shell /bin/bash \
        --uid 1000 \
        --gid 1000 \
        --groups docker \
        "${common_user}" \
    && install \
        --directory \
        --owner="${common_user}" \
        --group="${common_user}" \
        --mode=0700 \
        "${XDG_RUNTIME_DIR}" \
        "/home/${common_user}/.aws/cli" \
        "/home/${common_user}/.cache" \
        "/home/${common_user}/.config" \
        "/home/${common_user}/.java" \
        "/home/${common_user}/.local" \
        "/home/${common_user}/.ssh" \
        "/home/${common_user}/.terraform.d/plugin-cache" \
    && su \
        -c 'git clone --depth=1 --branch=v'"${tfenv_version}"' https://github.com/tfutils/tfenv.git /home/'"${common_user}"'/.tfenv' \
        "${common_user}" \
    && ln -s "/home/${common_user}/.tfenv/bin/"* /usr/local/bin

COPY --chown=${common_user}:${common_user} slash/home/${common_user}/ "/home/${common_user}/"

COPY --chown=root:root slash/bin/ /bin/

USER "${common_user}"

ENTRYPOINT ["/bin/entrypoint.sh"]
