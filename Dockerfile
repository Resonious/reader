FROM ruby:2.7.2

ENV _GIT_REVISION='development (kaiser)'
ARG UID=1000

# Setup 'app' user
RUN mkdir -p /app && \
useradd -U -u $UID --home-dir /app app && \
echo 'gem: --no-rdoc --no-ri' > ~/.gemrc

# Install system packages
RUN apt-get update && apt-get install -y curl git build-essential

# Install NPM
RUN wget https://nodejs.org/dist/v15.12.0/node-v15.12.0-linux-x64.tar.xz && \
tar -xf node-v15.12.0-linux-x64.tar.xz && \
cp -r node-v15.12.0-linux-x64/bin/* /usr/bin/ && \
cp -r node-v15.12.0-linux-x64/lib/* /usr/lib/ && \
cp -r node-v15.12.0-linux-x64/share/* /usr/share/

# Install yarn
RUN npm install -g yarn

RUN cd /app && ls

WORKDIR /app

ENV CONTAINER=true

ADD yarn.lock package.json /app/
RUN chown -R app /app && chgrp -R app /app

USER app

RUN yarn

EXPOSE 9000

CMD ["sh", "-c", "rails s -p 9000 -b 0.0.0.0"]
