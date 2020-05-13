FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev msmtp msmtp-mta ghostscript
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/local/bin/cc-test-reporter
RUN chmod +x /usr/local/bin/cc-test-reporter
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz && rm dockerize-linux-amd64-v0.6.1.tar.gz
RUN rm -f /usr/local/lib/ruby/gems/2.5.0/specifications/default/fileutils-1.0.2.gemspec
RUN useradd -ms /bin/bash charon
USER charon
RUN mkdir -p /home/charon/web
RUN mkdir -p /home/charon/images
WORKDIR /home/charon/web
COPY --chown=charon:charon . /home/charon/web
RUN bundle install
RUN cp /home/charon/web/scripts/msmtprc /home/charon/.msmtprc
