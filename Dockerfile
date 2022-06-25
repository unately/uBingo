FROM ghcr.io/upackages/java:17

# Labels for Github packages
LABEL maintainer="hello@unately.com"
LABEL org.opencontainers.image.source https://github.com/unately/ubingo
LABEL org.opencontainers.image.description Development Version


# Setup environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl wget bash dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 25565 25567
COPY dockerfiles/mc-send-to-console /usr/local/bin/mc-console
RUN dos2unix /usr/local/bin/mc-console

# Build modpack
WORKDIR /modpack

COPY . .
RUN wget https://github.com/froehlichA/pax/releases/latest/download/pax && \ 
    chmod +x pax && \
    ./pax export && \
    mkdir /server && \
    mv .out/*.zip /server/modpack.zip
WORKDIR /
RUN rm -r modpack

# Setup Server
WORKDIR /server

COPY dockerfiles/server-install-script install.sh
COPY dockerfiles/docker-setup-config.yaml server-setup-config.yaml

RUN chmod 0777 install.sh && \
    dos2unix install.sh && \
    sh install.sh && \
    rm install.sh

# COPY --chmod=755 dockerfiles/mc-health /health.sh

# Run the thing

STOPSIGNAL SIGTERM
CMD sh run.sh

# HEALTHCHECK --start-period=1m CMD mc-health
