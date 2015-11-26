FROM node:0.12

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs 

# Install Cloud9 IDE
RUN git clone git://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN wget https://raw.githubusercontent.com/c9/install/master/install.sh && sed -i -e 's_install pty.js_install --unsafe-perm pty.js_g' install.sh  && bash install.sh && rm -rf install.sh
RUN scripts/install-sdk.sh

RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# Declare volume for workspace storage
RUN mkdir /workspace
WORKDIR /workspace
VOLUME ["/workspace"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# WebUI
EXPOSE 80
# Node listen port
EXPOSE 3000


# Start container services
CMD /usr/local/bin/node /cloud9/server.js --port 80 -w /workspace --listen 0.0.0.0
