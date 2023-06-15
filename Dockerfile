FROM debian:bullseye-slim AS builder
RUN apt-get update && apt-get install -y git wget curl libzmq3-dev build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libdb-dev libdb++-dev
RUN mkdir -p /tmp /scripts
ADD install /scripts
RUN /scripts/install

FROM debian:bullseye-slim
COPY --from=builder /usr/local/bin/elementsd /usr/local/bin/elementsd
COPY --from=builder /usr/local/bin/elements-cli /usr/local/bin/elements-cli
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /lib /lib

RUN apt-get update
RUN apt-get install libc6
RUN useradd -ms /bin/bash elements 
USER elements

RUN mkdir -p "$HOME/.elements/"
ENTRYPOINT ["elementsd"]
