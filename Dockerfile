# Use a base image with wget and dpkg
FROM debian:bookworm-slim AS downloader

# Install wget
RUN apt-get update && apt-get install -y wget

# ARG for architecture
ARG TARGETARCH

# Download the appropriate motionplus package
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -O motionplus.deb https://github.com/Motion-Project/motionplus/releases/download/release-0.2.1/bookworm_motionplus_0.2.1-1_amd64.deb; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -O motionplus.deb https://github.com/Motion-Project/motionplus/releases/download/release-0.2.1/bookworm_motionplus_0.2.1-1_arm64.deb; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; exit 1; \
    fi

# Create final image
FROM debian:bookworm-slim

# Set the same ARG in the final stage
ARG TARGETARCH

# Copy the downloaded .deb file from the previous stage
COPY --from=downloader /motionplus.deb /tmp/motionplus.deb
WORKDIR /tmp
RUN apt-get update
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        apt-get install gnupg wget -y; \
        echo 'deb http://archive.raspberrypi.org/debian/ bookworm main' > /etc/apt/sources.list; \
        wget -O - https://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add - ;\
        apt update; \
    fi

# Install the motionplus package
RUN apt install ./motionplus.deb --yes && dpkg -i motionplus.deb && apt install -f --yes

# Create necessary directories
RUN mkdir -p /var/motionsplus/

# Set the command to run the motionplus application
CMD ["motionplus"]
