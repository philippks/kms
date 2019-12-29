FROM ruby:2.6.5 AS base
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y \
    libpq-dev \
    cmake \
    nodejs \
    wkhtmltopdf

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install --without test development

ADD package*.json $APP_HOME/
RUN npm install
ENTRYPOINT ["/app/docker-entrypoint.sh"]


FROM base AS development
ENV RAILS_ENV development

RUN bundle install --with development
# files are mounted in development
# ADD . $APP_HOME
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


FROM development AS test
ENV RAILS_ENV test

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install \
    && rm google-chrome-stable_current_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN bundle install --with test development

# files are mounted in tests
# ADD . $APP_HOME
CMD ["bundle", "exec", "rspec"]


FROM base AS kms
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
ADD . $APP_HOME
RUN SECRET_KEY_BASE=tmp rails assets:precompile
CMD ["bundle", "exec", "rails", "server"]
