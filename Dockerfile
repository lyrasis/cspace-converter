FROM alpine:3.7

ENV BUILD_DATE=false \
    BUILD_VERSION=${SOURCE_BRANCH:-dev} \
    BUNDLER_VERSION=1.17.3 \
    ENV="/etc/profile" \
    TERM=linux \
    PS1="\n\n>> ruby \W \$ " \
    TZ=UTC

RUN echo "export BUILD_DATE=`date '+%Y-%m-%d'`" >> $ENV \
    apk --no-cache add \
    bash \
    build-base \
    curl \
    curl-dev \
    dcron \
    libffi-dev \
    nodejs \
    ruby \
    ruby-bigdecimal \
    ruby-dev \
    ruby-io-console \
    ruby-irb \
    ruby-json \
    tzdata \
    zlib-dev \
    && \
    echo 'gem: --no-document' > /etc/gemrc && gem install bundler -v ${BUNDLER_VERSION} && \
    bundle config --global silence_root_warning 1

RUN mkdir -p /usr/app/
WORKDIR /usr/app

COPY Gemfile* /usr/app/
RUN bundle install

COPY . /usr/app/
CMD crond && bundle exec whenever --update-crontab && bundle exec rails s -b 0.0.0.0
