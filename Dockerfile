FROM alpine:latest

LABEL maintainer="lucebac <docker@lucebac.net>"

RUN apk add -U --no-cache curl unzip nodejs nodejs-npm sqlite openssl git python file \
    && adduser -D ctfpad \
    && mkdir /ctfpad && chown ctfpad:ctfpad /ctfpad \
    && chown ctfpad:ctfpad -R /ctfpad

WORKDIR /ctfpad

# setup ctfpad
RUN cd /ctfpad \
    && git clone https://github.com/ENOFLAG/CTFPad ctfpad \
    && cd ctfpad \ 
    && npm install \
    && chown ctfpad:ctfpad -R /ctfpad

# setup underlying etherpad
RUN cd /ctfpad/ctfpad \
    && git clone https://github.com/ether/etherpad-lite.git etherpad-lite \
    && ./etherpad-lite/bin/installDeps.sh \
    && rm etherpad-lite/settings.json \
    && chown ctfpad:ctfpad -R /ctfpad

# add config files
ADD config.template.json /ctfpad/ctfpad/config.template.json
ADD settings.template.json /ctfpad/ctfpad/etherpad-lite/settings.template.json

WORKDIR /ctfpad/ctfpad

VOLUME ["/data"]

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 4242 4343
CMD ["su", "ctfpad", "-c", "node main.js"]
