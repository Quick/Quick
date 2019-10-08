ARG swift_version
FROM swift:${swift_version}

ENV SWIFT_VERSION=$swift_version

WORKDIR /package

COPY . ./

RUN apt-get -q update && \
    apt-get -q install -y \
    lsb-release \
    rake

ENTRYPOINT ./script/travis-script-linux
