# OS System
FROM ubuntu:18.04

RUN apt-get update -y && \
  apt-get upgrade -y

# Install basics
RUN apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  zip \
  unzip \
  gnupg \
  xz-utils \
  libglu1-mesa \
  openjdk-8-jdk \
  clang \
  cmake \
  libgtk-3-dev \
  ninja-build \
  pkg-config

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Install chrome stable

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-31" "sources;android-31" "cmdline-tools;latest"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/home/developer/flutter/bin"

# Predescargue los binarios de desarrollo
RUN flutter precache

# Establecer ruta del sdk de Android
RUN flutter config --android-sdk "${ANDROID_SDK_ROOT}"

# No enviar informes de uso de flutter a google
RUN flutter config --no-analytics 

# Scan sdk Flutter
RUN flutter doctor



