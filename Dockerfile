FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev ssmtp
#https://github.com/docker-library/ruby/issues/226https://github.com/docker-library/ruby/issues/226
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs
RUN sed -i 's/mailhub=mail/mailhub=172.17.0.1/' /etc/ssmtp/ssmtp.conf
RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
RUN mkdir /charon
WORKDIR /charon
COPY Gemfile /charon/Gemfile
COPY Gemfile.lock /charon/Gemfile.lock
RUN bundle install
COPY . /charon
