# Loosely based on https://www.fpcomplete.com/blog/2017/12/building-haskell-apps-with-docker
FROM fpco/stack-build:lts-19.7 as dependencies
RUN mkdir /opt/build
WORKDIR /opt/build

# Docker build should not use cached layer if any of these is modified
COPY stack.yaml package.yaml stack.yaml.lock /opt/build/
RUN stack build --system-ghc --dependencies-only

# -------------------------------------------------------------------------------------------
FROM fpco/stack-build:lts-19.7 as build

# Copy compiled dependencies from previous stage
COPY --from=dependencies /root/.stack /root/.stack
COPY . /opt/build/

WORKDIR /opt/build

RUN stack build --system-ghc

RUN mv "$(stack path --local-install-root --system-ghc)/bin" /opt/build/bin

# -------------------------------------------------------------------------------------------
# Base image for stack build so compiled artifact from previous
# stage should run
FROM debian:stable-slim as app
RUN mkdir -p /opt/app
WORKDIR /opt/app

ENV DEBIAN_FRONTEND=noninteractive 
RUN apt update && apt install libgmp-dev libpcre3 -y && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/build/bin .

ENV PORT 3000
EXPOSE 3000

CMD ["/opt/app/learning-k8s-exe"]
