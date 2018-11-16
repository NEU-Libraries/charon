FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /charon
WORKDIR /charon
COPY Gemfile /charon/Gemfile
COPY Gemfile.lock /charon/Gemfile.lock
RUN bundle install
COPY . /charon
