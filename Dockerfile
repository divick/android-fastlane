ARG OPENJDK_VERSION="14"

FROM openjdk:${OPENJDK_VERSION}-slim
LABEL maintainer Divick K.<divick@gorapid.io>

ARG CMDLINE_TOOLS_VERSION
ARG BUILD_TOOLS
ARG TARGET_SDK
ARG ANDROID_HOME
ARG RUBY_VERSION
ARG FASTLANE_VERSION

# Check if the build args to docker build have been passed or not
RUN test -n "$CMDLINE_TOOLS_VERSION"
RUN test -n "$BUILD_TOOLS"
RUN test -n "$TARGET_SDK"
RUN test -n "$ANDROID_HOME"
RUN test -n "$RUBY_VERSION"
RUN test -n "$FASTLANE_VERSION"

# Specify the environment variables (which are available inside the
# container when using `docker run` command) as well as during the
# `docker build` command
ENV CMDLINE_TOOLS_VERSION="${CMDLINE_TOOLS_VERSION}" \
    BUILD_TOOLS="${BUILD_TOOLS}" \
    TARGET_SDK="${TARGET_SDK}" \
    ANDROID_HOME="${ANDROID_HOME}" \
    RUBY_VERSION="${RUBY_VERSION}" \
    PATH=/root/.rbenv/shims:/root/.rbenv/bin:/root/.rbenv/plugins/ruby-build/bin:$PATH

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
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/tools.zip \
    && mkdir -p ${ANDROID_HOME} \
    && unzip /tmp/tools.zip -d ${ANDROID_HOME} \
    && rm -v /tmp/tools.zip \
    && mkdir -p /root/.android/ \
    && touch /root/.android/repositories.cfg \
    && yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "--licenses" \
    && ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "--update" \
    && ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "emulator" \
    && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build \
    && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
    && echo 'eval "$(rbenv init -)"' >> /root/.bashrc \
    && mkdir -p "$(rbenv root)"/plugins \
    && rbenv install ${RUBY_VERSION} \
    && rbenv global ${RUBY_VERSION} \
    && gem install bundler \
    && gem install fastlane -v ${FASTLANE_VERSION}
