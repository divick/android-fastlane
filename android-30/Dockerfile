ARG OPENJDK_VERSION="8"

FROM openjdk:${OPENJDK_VERSION}-slim
LABEL maintainer Divick K.<divick@gorapid.io>

ARG CMDLINE_TOOLS_VERSION="7302050"
ARG BUILD_TOOLS="29.0.3"
ARG TARGET_SDK="30"
ARG RUBY_VERSION="3.0.2"
ARG FASTLANE_VERSION="2.199.0"

# Check if the build args to docker build have been passed or not
RUN test -n "$CMDLINE_TOOLS_VERSION"
RUN test -n "$BUILD_TOOLS"
RUN test -n "$TARGET_SDK"
RUN test -n "$RUBY_VERSION"
RUN test -n "$FASTLANE_VERSION"

# Specify the environment variables (which are available inside the
# container when using `docker run` command) as well as during the
# `docker build` command
ENV HOME=/root
ENV ANDROID_HOME=$HOME/android

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
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/tools.zip \
    && mkdir -p ${ANDROID_HOME} \
    && unzip /tmp/tools.zip -d ${ANDROID_HOME} \
    && rm -v /tmp/tools.zip \
    && mkdir -p $HOME/.android/ \
    && touch $HOME/.android/repositories.cfg \
    && yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME}/sdk "--licenses" \
    && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME}/sdk "--update" \
    && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME}/sdk "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "emulator" \
    && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    && ~/.rbenv/plugins/ruby-build/install.sh \
    && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
    && echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc \
    && ~/.rbenv/bin/rbenv install ${RUBY_VERSION} \
    && ~/.rbenv/bin/rbenv global ${RUBY_VERSION} \
    && ~/.rbenv/shims/gem install bundler \
    && ~/.rbenv/shims/gem install fastlane -v ${FASTLANE_VERSION}

ENV ANDROID_SDK_ROOT=$ANDROID_HOME/sdk
ENV PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$ANDROID_HOME/sdk/tools:$ANDROID_HOME/sdk/tools/bin:$ANDROID_HOME/sdk/build-tools/$BUILD_TOOLS:$ANDROID_HOME/sdk/platform-tools:$ANDROID_HOME/cmdline-tools/bin:$PATH
