# OS System
FROM debian:bullseye

RUN apt-get update -y && \
  apt-get upgrade -y

# Install basics
RUN apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  zip \
  unzip \
  apt-transport-https \
  ca-certificates \
  gnupg

# Add repo for chrome stable
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | \
    tee /etc/apt/sources.list.d/google-chrome.list

# Add repo for OpenJDK 8 from JFrog.io
RUN wget -q -O - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN echo 'deb [arch=amd64] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main' | \
    tee /etc/apt/sources.list.d/adoptopenjdk.list

# Install the dependencies needed for the rest of the build.
RUN apt-get update && apt-get install -y --no-install-recommends \
  adoptopenjdk-8-hotspot \
  build-essential \
  default-jdk-headless \
  gcc \
  google-chrome-stable \
  lib32stdc++6 \
  libglu1-mesa \
  libstdc++6 && \
  apt-get clean

ENV JAVA_HOME="/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64"

# Install the Android SDK Dependency.
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_TOOLS_ROOT="/Android/sdk"
RUN mkdir -p "${ANDROID_TOOLS_ROOT}"
RUN mkdir -p ~/.android
# Silence warning.
RUN touch ~/.android/repositories.cfg
ENV ANDROID_SDK_ARCHIVE="${ANDROID_TOOLS_ROOT}/archive"
RUN wget --progress=dot:giga "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_TOOLS_ROOT}" "${ANDROID_SDK_ARCHIVE}"
# Suppressing output of sdkmanager to keep log size down
# Aceptar licencias de Android
RUN cd "${ANDROID_TOOLS_ROOT}/tools/bin" && yes | ./sdkmanager --licenses
# (it prints install progress WAY too often).
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "tools" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "build-tools;29.0.2" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "platforms;android-30" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "sources;android-30" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "platform-tools" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "cmdline-tools;latest" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "extras;android;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "extras;google;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "patcher;v4" > /dev/null
RUN rm "${ANDROID_SDK_ARCHIVE}"
ENV PATH="${ANDROID_TOOLS_ROOT}/tools:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/tools/bin:${PATH}"
ENV PATH "$PATH:${ANDROID_TOOLS_ROOT}/platform-tools"
# Silence warnings when accepting android licenses.
RUN mkdir -p ~/.android
RUN touch ~/.android/repositories.cfg

# Install dependencies for desktop flutter run
RUN apt-get install -y --no-install-recommends \
  clang \
  cmake \
  libgtk-3-dev \
  ninja-build \
	pkg-config \
	x11-xserver-utils \
	xauth \
	xvfb && \
  apt-get upgrade -y --no-install-recommends && \
  apt-get clean

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/home/developer/flutter/bin"

# Predescargue los binarios de desarrollo
RUN flutter precache

# Enable desktop\web support
RUN flutter config --enable-linux-desktop && flutter config --enable-web

# Establecer ruta del sdk de Android
RUN flutter config --android-sdk "${ANDROID_TOOLS_ROOT}"

# No enviar informes de uso de flutter a google
RUN flutter config --no-analytics 

# Scan sdk Flutter
RUN flutter doctor



