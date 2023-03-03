FROM gcr.io/google_appengine/ruby
COPY . /app/

RUN rbenv install 3.2.1
RUN rbenv rehash

ENV RACK_ENV=production \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

RUN if test -d app/assets -a -f config/application.rb; then \
    bundle exec rake assets:precompile; \
    fi

ENTRYPOINT []
CMD bundle exec rackup -p $PORT