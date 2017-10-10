FROM java:8

MAINTAINER Stefan Bieler <stefan.bieler@asideas.de>

#=========
# Env variables
#=========
ENV CHROME_VERSION=61.*
ENV CHROME_DRIVER_VERSION=2.33
ENV webdriver.chrome.driver=/usr/bin/chromedriver

#=========
# Adding Headless Selenium with Chrome and Firefox
#=========

# Install unzip and chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y \
	google-chrome-stable=$CHROME_VERSION \
	unzip

# Chrome driver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/
RUN chmod ugo+rx /usr/bin/chromedriver

# Dependencies to make "headless" selenium work
RUN apt-get -y install \
	gtk2-engines-pixbuf \
	libxtst6 \
	xfonts-100dpi \
	xfonts-75dpi \
	xfonts-base \
	xfonts-cyrillic \
	xfonts-scalable \
	xvfb

# Starting xfvb as a service
ENV DISPLAY=:99
ADD xvfb /etc/init.d/
RUN chmod 755 /etc/init.d/xvfb
