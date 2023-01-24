FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y git vim gcc g++ flex bison make autoconf pkg-config libpcre3-dev
RUN git clone https://github.com/kamailio/kamailio /src
WORKDIR /src
RUN git checkout 5.6.3
RUN make
RUN make install
ENTRYPOINT ["kamailio", "-DD"]
