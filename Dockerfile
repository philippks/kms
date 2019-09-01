FROM ruby:2.6.3 AS base

RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y \
    libpq-dev \
    cmake \
    nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install --without test development

ADD package*.json $APP_HOME/
RUN npm install

ADD . $APP_HOME

CMD ["bundle", "exec", "rails", "server"]


FROM base AS test

RUN apt-get update \
    && curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb \
    && dpkg -i /chrome.deb; apt-get -fy install \
    && rm /chrome.deb
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR $APP_HOME
RUN bundle install --with test development

CMD ["bundle", "exec", "rspec"]
