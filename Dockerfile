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

# ENTRYPOINT []
# # I think we can set '3000' back to $PORT in deployment, but for now it breaks when I do things locally, so I just set it explicitly.
CMD bundle exec rackup -p 8080