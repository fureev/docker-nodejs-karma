FROM node:8

# Install Google Chrome
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update && apt-get install -y Xvfb google-chrome-stable --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install chromedriver for e2e tests to: /usr/local/lib/node_modules/webdriver-manager/selenium/chromedriver_*
RUN npm install -g webdriver-manager
RUN webdriver-manager update --standalone false --gecko false

ADD xvfb.sh /etc/init.d/xvfb
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/bin/Xvfb \
    && chmod +x /entrypoint.sh \
    && touch /var/run/xvfb.pid

USER node

ENV DISPLAY :99.0
ENV CHROME_BIN /usr/bin/google-chrome

ENTRYPOINT ["/entrypoint.sh"]
