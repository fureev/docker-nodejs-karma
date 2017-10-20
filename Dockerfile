FROM node:8

<<<<<<< Updated upstream
# Install Google Chrome
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update && apt-get install -y Xvfb google-chrome-stable \
=======
# Install Chrome 56
RUN wget --progress=bar -O /tmp/chrome-56.deb https://www.slimjet.com/chrome/download-chrome.php?file=lnx%2Fchrome64_56.0.2924.87.deb \
    && apt-get -qq update && apt-get install -y Xvfb libpango1.0-0 libpangox-1.0-0 libpangoxft-1.0-0 libnspr4 libnspr4-0d gconf-service libasound2 libatk1.0-0 libcups2 libdbus-1-3 libgconf-2-4 libgtk2.0-0 libnss3 libnss3-1d libxss1 libxtst6 fonts-liberation libappindicator1 xdg-utils \
    && dpkg -i /tmp/chrome-56.deb \
>>>>>>> Stashed changes
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD xvfb.sh /etc/init.d/xvfb
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/bin/Xvfb \
    && chmod +x /entrypoint.sh
RUN touch /var/run/xvfb.pid \
    && chown node:node /var/run/xvfb.pid /usr/bin/Xvfb

USER node

ENV DISPLAY :99.0
ENV CHROME_BIN /usr/bin/google-chrome

<<<<<<< Updated upstream
RUN yarn global add @angular/cli@latest && rm -rf $(yarn cache dir)

=======
>>>>>>> Stashed changes
ENTRYPOINT ["/entrypoint.sh"]
