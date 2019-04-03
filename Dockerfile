FROM ruby:2.6.1-alpine3.9

RUN apk --update --no-cache add build-base git

ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH 
WORKDIR $INSTALL_PATH

EXPOSE 80
VOLUME /srv/configs /srv/scripts

# get latest bundler (base image has older one)
RUN gem update bundler 

ADD . $INSTALL_PATH
RUN bundle install

CMD ["bundle", "exec", "./exe/hookd", "-p", "80"]
