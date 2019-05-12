FROM centrifugo/centrifugo:v2.2.0
MAINTAINER Felipe Signorini <felipe.signorini@maestroserver.io>

RUN apk add --no-cache tini jq


ADD ./devtools/pems/server.key /tmp/certs/server.key
ADD ./devtools/pems/server.crt /tmp/certs/server.crt
ADD ./run_start_container.sh /opt/run_start_container.sh

RUN chmod +x /opt/run_start_container.sh

ENTRYPOINT ["/sbin/tini","-g","--"]
CMD ["/opt/run_start_container.sh"]
