FROM ruby:3.2.1

ENV RACK_ENV=production

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 5000
CMD ["./bin/start.sh"]
