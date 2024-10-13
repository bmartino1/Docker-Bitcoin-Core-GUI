# # # Stage 1 # # #
# Download bitcoin-core
FROM jlesage/baseimage-gui:debian-12-v4.6.4 AS download
ARG DOWNLOAD_URL="https://bitcoin.org/bin/bitcoin-core-27.0/bitcoin-27.0-x86_64-linux-gnu.tar.gz"

RUN apt-get -yq update && apt-get -yq install curl

WORKDIR /
RUN curl "${DOWNLOAD_URL}" --output "bitcoin-core.tar.gz"
RUN tar -xzf "bitcoin-core.tar.gz"

# # # Stage 2 # # #
# Setup the final image
FROM jlesage/baseimage-gui:debian-12-v4.6.4
ARG APP_ICON="https://bitcoin.org/img/icons/opengraph.png"
ENV APP_NAME="BitcoinCoreGUI"

# Install necessary libraries for bitcoin-qt and bitcoind
RUN apt-get -yq update && apt-get -yq install \
    libfontconfig1 \
    libxcb1 \
    libxrender1 \
    libxcb-icccm4 \
    libxkbcommon-x11-0 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    build-essential \
    autoconf \
    libssl-dev \
    libboost-dev \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libqt4-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libqrencode-dev \
    libdb5.3++-dev \
    libdb5.3-dev \
    unattended-upgrades

# Configure unattended-upgrades for automatic updates
RUN echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections && \
    dpkg-reconfigure --frontend=noninteractive unattended-upgrades

# Set up the application icon and Bitcoin Core
RUN install_app_icon.sh "${APP_ICON}"

# Copy bitcoin-qt from the downloaded image and make it executable
COPY --from=download /bitcoin-27.0/bin/bitcoin-qt /usr/local/bin/
RUN chmod +x /usr/local/bin/bitcoin-qt

# Create startapp.sh script and make it executable
RUN echo '#!/bin/sh' > /startapp.sh && \
    echo 'set -ex' >> /startapp.sh && \
    echo 'export HOME=/config' >> /startapp.sh && \
    echo 'exec bitcoin-qt' >> /startapp.sh && \
    chmod +x /startapp.sh

VOLUME /config
