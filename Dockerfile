FROM ruby:2.7.1

RUN apt-get update -qq && \
    apt-get install -y build-essential \ 
                       libpq-dev \        
                       nodejs \
   && rm -rf /var/lib/apt/lists/* 

RUN mkdir /gakutika_backend
ENV APP_ROOT /gakutika_backend
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install