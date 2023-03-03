FROM ruby:3.2.1

ARG SECRET_KEY_BASE

COPY . /app/
WORKDIR /app/

ENV RACK_ENV=production \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    SECRET_KEY_BASE=<PLACEHOLDER__SECRET_KEY_BASE>

RUN echo $SECRET_KEY_BASE
RUN echo $RACK_ENV

RUN gem install bundler
RUN bundle install

RUN bundle exec rake assets:precompile

ENTRYPOINT []
CMD bundle exec rackup -p 8080