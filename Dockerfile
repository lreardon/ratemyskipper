FROM ruby:3.2.1

COPY . /app/
WORKDIR /app/

ENV RACK_ENV=production \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN gem install bundler
RUN bundle install

RUN if test -d app/assets -a -f config/application.rb; then \
    bundle exec rake assets:precompile; \
    fi

ENTRYPOINT []
# I think we can set '3000' back to $PORT in deployment, but for now it breaks when I do things locally, so I just set it explicitly.
CMD bundle exec rackup -p 3000