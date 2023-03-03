FROM ruby:3.2.1

COPY . /app/
WORKDIR /app/

ENV RACK_ENV=production \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

RUN gem install bundler
RUN bundle install

RUN if test -d app/assets -a -f config/application.rb; then \
    bundle exec rake assets:precompile; \
    fi

ENTRYPOINT []
CMD bundle exec rackup -p 3000