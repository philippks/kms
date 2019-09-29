FROM ruby:2.6.3 AS base
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y \
    libpq-dev \
    cmake \
    nodejs

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install --without test development

ADD package*.json $APP_HOME/
RUN npm install

FROM base AS kms
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
ADD . $APP_HOME
CMD ["bundle", "exec", "rails", "server"]


FROM base AS development
RUN bundle install --with development
ADD . $APP_HOME
CMD ["bundle", "exec", "rails", "server"]


FROM development AS test
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -i /chrome.deb \
    && dpkg -i /chrome.deb; apt-get -fy install \
    && rm /chrome.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN bundle install --with test development
ADD . $APP_HOME

CMD ["bundle", "exec", "rspec"]
