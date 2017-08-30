FROM ruby:2.4-slim

MAINTAINER Fredrik Wallgren <fredrik.wallgren@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN buildDependencies=' \
      build-essential \
    ' \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests ${buildDependencies} \
 && gem install gimli \
 && apt-get purge -y --auto-remove ${buildDependencies} \
 && rm -rf /var/lib/apt/lists/*

# Make this image a wrapper for the CLI
ENTRYPOINT ["gimli"]

# Show the extended help by default
CMD ["-h"]
