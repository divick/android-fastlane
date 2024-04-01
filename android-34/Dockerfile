ARG JDK_VERSION="17.0.10_7"

FROM eclipse-temurin:${JDK_VERSION}-jdk-jammy
LABEL maintainer Divick K.<divick@gorapid.io>

ARG CMDLINE_TOOLS_VERSION="11076708"
ARG BUILD_TOOLS="34.0.0"
ARG TARGET_SDK="34"
ARG RUBY_VERSION="3.3.0"
ARG FASTLANE_VERSION="2.219.0"
ARG USER="docker"
ARG UID=1000
ARG GID=1000

# Check if the build args to docker build have been passed or not
RUN test -n "$CMDLINE_TOOLS_VERSION"
RUN test -n "$BUILD_TOOLS"
RUN test -n "$TARGET_SDK"
RUN test -n "$RUBY_VERSION"
RUN test -n "$FASTLANE_VERSION"

# Specify the environment variables (which are available inside the
# container when using `docker run` command) as well as during the
# `docker build` command
ENV HOME=/home/$USER \
    ANDROID_HOME=/home/$USER/android

# 1. Install required dependencies via apt
# 2. Download and extract Android android sdk and tools
# 3. Install rbenv to install required ruby version
# 4. Install ruby
# 5. Install fastlane
RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        libssl-dev \
        libreadline-dev \
        zlib1g-dev \
        gcc \
        g++ \
        make \
        wget \
        unzip \
        bzip2 \
        git \
        curl \
        librsvg2-2 \
        imagemagick \
        libffi-dev \
        libyaml-dev \
        xz-utils \
    && useradd -m -u $UID -s /bin/bash -U $USER \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/tools.zip \
    && mkdir -p ${ANDROID_HOME} \
    && unzip /tmp/tools.zip -d ${ANDROID_HOME} \
    && rm -v /tmp/tools.zip \
    && mkdir -p $HOME/.android/ \
    && touch $HOME/.android/repositories.cfg \
    && yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager \
        --sdk_root=${ANDROID_HOME} "--licenses" \
    && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager \
        --sdk_root=${ANDROID_HOME} "--update" \
    && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager \
        --sdk_root=${ANDROID_HOME} \
        "build-tools;${BUILD_TOOLS}" \
        "platform-tools" \
        "platforms;android-${TARGET_SDK}" \
        "extras;android;m2repository" \
        "extras;google;google_play_services" \
        "extras;google;m2repository" \
        "emulator" \
    && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    && ~/.rbenv/plugins/ruby-build/install.sh \
    && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
    && echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc \
    && ~/.rbenv/bin/rbenv install ${RUBY_VERSION} \
    && ~/.rbenv/bin/rbenv global ${RUBY_VERSION} \
    && ~/.rbenv/shims/gem install bundler \
    && ~/.rbenv/shims/gem install fastlane -v ${FASTLANE_VERSION} \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

RUN chown -R $UID:$GID $HOME/.android \
    && chown -R $UID:$GID $ANDROID_HOME \
    && chown -R $UID:$GID $HOME/.rbenv \
    && chown -R $UID:$GID $HOME/.local

ENV ANDROID_SDK_ROOT=$ANDROID_HOME/sdk
ENV PATH="$HOME/.rbenv/bin:$ANDROID_HOME/sdk/tools:$ANDROID_HOME/emulator:$ANDROID_HOME/emulator/bin64:$ANDROID_HOME/sdk/build-tools/$BUILD_TOOLS:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin:$PATH"

USER ${UID}:${GID}
WORKDIR $HOME
