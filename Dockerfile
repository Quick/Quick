FROM swift:4.0.3

WORKDIR /package

ENV SWIFT_VERSION=4.0.3

COPY . ./

RUN apt-get -q update && \
    apt-get -q install -y \
    lsb-release \
    rake

RUN ./script/travis-install-linux

ENTRYPOINT ./script/travis-script-linux
