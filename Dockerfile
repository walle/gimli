FROM nepalez/ruby:latest

MAINTAINER Fredrik Wallgren <fredrik.wallgren@gmail.com>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y libfontconfig1 libxtst6 build-essential xorg libssl-dev libxrender-dev

# Install gimli
RUN gem install gimli

ENTRYPOINT ["/usr/local/bin/gimli"]

# Show the extended help
CMD ["-h"]