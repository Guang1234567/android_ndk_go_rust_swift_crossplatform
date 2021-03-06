FROM circleci/android:api-30

# NDK see also: https://github.com/CircleCI-Public/circleci-dockerfiles/blob/cb8bda793023d3e919ea5553e2f2c04b71f53c49/android/images/api-28-ndk/Dockerfile#L181

ARG go_version=1.14.7
# ARG ndk_version=21.3.6528147
ARG ndk_version=20.1.5948944
ARG android_ndk_home=${android_home}/ndk/${ndk_version}

# install NDK
RUN sdkmanager --install "ndk;${ndk_version}"
ENV ANDROID_NDK_HOME ${android_ndk_home}

# install go
RUN \
    curl --silent --show-error --location --fail --retry 3 --output /tmp/go${go_version}.tgz \
    "https://dl.google.com/go/go${go_version}.linux-amd64.tar.gz" && \
    sudo tar -C /usr/local -xzf /tmp/go${go_version}.tgz; \
    rm /tmp/go${go_version}.tgz
ENV PATH /usr/local/go/bin:$PATH

# install rust

# rustup_dist_server_url="https://static.rust-lang.org"
ARG rustup_dist_server_url="https://mirrors.tuna.tsinghua.edu.cn/rustup"
ARG rustup_update_root_url="${rustup_dist_server_url}/rustup"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.45.2 \
    RUSTUP_DIST_SERVER=${rustup_dist_server_url} \
    RUSTUP_UPDATE_ROOT=${rustup_update_root_url}

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='ad1f8b5199b3b9e231472ed7aa08d2e5d1d539198a15c5b1e53c746aad81d27b' ;; \
    armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='6c6c3789dabf12171c7f500e06d21d8004b5318a5083df8b0b02c0e5ef1d017b' ;; \
    arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='26942c80234bac34b3c1352abbd9187d3e23b43dae3cf56a9f9c1ea8ee53076d' ;; \
    i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='27ae12bc294a34e566579deba3e066245d09b8871dc021ef45fc715dced05297' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="$RUSTUP_UPDATE_ROOT/archive/1.21.1/${rustArch}/rustup-init"; \
    sudo wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    sudo chmod +x rustup-init; \
    sudo RUSTUP_HOME=/usr/local/rustup CARGO_HOME=/usr/local/cargo ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    sudo rm rustup-init; \
    sudo chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# setup rust targets
RUN \
    rustup target add armv7-linux-androideabi; \
    rustup target add i686-linux-android; \
    rustup target add aarch64-linux-android; \
    rustup target add x86_64-linux-android

WORKDIR ${HOME}
COPY .cargo ./.cargo
RUN \
    /bin/bash -c "source ~/.cargo/env"
