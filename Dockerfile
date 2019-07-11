FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev ssmtp
#https://github.com/docker-library/ruby/issues/226https://github.com/docker-library/ruby/issues/226
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs
RUN sed -i 's/mailhub=mail/mailhub=172.17.0.1/' /etc/ssmtp/ssmtp.conf
RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/local/bin/cc-test-reporter
RUN chmod +x /usr/local/bin/cc-test-reporter
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz && rm dockerize-linux-amd64-v0.6.1.tar.gz
RUN useradd -ms /bin/bash charon
USER charon
RUN mkdir -p /home/charon/web
WORKDIR /home/charon/web
COPY Gemfile /home/charon/web/Gemfile
COPY Gemfile.lock /home/charon/web/Gemfile.lock
RUN bundle install
COPY --chown=charon:charon . /home/charon/web
