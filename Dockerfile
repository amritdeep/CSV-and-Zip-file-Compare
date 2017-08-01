FROM ruby:2.2.1
# FROM ruby:2.2 

RUN apt-get update -qq && apt-get install build-essential nodejs -y

RUN mkdir -p /project
WORKDIR /project

ADD Gemfile /project/Gemfile
ADD Gemfile.lock /project/Gemfile.lock

RUN gem install bundler && bundle install

ADD . /project

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]