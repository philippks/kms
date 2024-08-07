FROM ruby:3.3.2 AS base
RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash \
    && apt-get install --no-install-recommends -y \
    libpq-dev \
    cmake \
    nodejs \
    wkhtmltopdf \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD package*.json $APP_HOME/
RUN npm install


################################################################################################
#### Test
################################################################################################
FROM base AS test
ENV RAILS_ENV test

RUN wget --no-verbose https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb; apt-get update && apt-get -fy install \
    && rm google-chrome-stable_current_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD Gemfile* $APP_HOME/
RUN bundle config set --local with 'test development' && bundle install --jobs 3

ADD . $APP_HOME
CMD ["bundle", "exec", "rspec"]


################################################################################################
#### Production
################################################################################################
FROM base AS production
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

ADD Gemfile* $APP_HOME/
RUN bundle install --jobs 3 --without test development

ADD . $APP_HOME
RUN SECRET_KEY_BASE=tmp rails assets:precompile
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server"]
