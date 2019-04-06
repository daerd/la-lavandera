FROM ruby:2.6.1-alpine

MAINTAINER Daniel Herrero <daniel.herrero.101@gmail.com>

# Installs all the system's dependencies.
RUN apk add --update --no-cache \
      build-base \
      bash \
      git \
      openssh \
      npm \
      nodejs \
      lftp \
    && rm -rf /var/cache/apk/*

# Creates the project's main path and sets it as the current directory.
ENV     INSTALL_PATH /la_lavandera
RUN     mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Updates the gem system to avoid incompatibilities with the defined Ruby version and installs all the gems.
COPY Gemfile Gemfile.lock ./
RUN  gem update --system && gem install bundler
RUN  bundle install

# Installs Webpack and all its dependencies.
COPY package*.json ./
RUN npm install

COPY . .
