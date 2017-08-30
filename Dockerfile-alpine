FROM ruby:2.4-alpine

MAINTAINER Fredrik Wallgren <fredrik.wallgren@gmail.com>

RUN apk --update add --no-cache --virtual .gimli-build-dependencies \
      build-base \
 && gem install gimli \
 && apk del .gimli-build-dependencies

ENTRYPOINT ["gimli"]

# Show the extended help
CMD ["-h"]
