FROM centrifugo/centrifugo
MAINTAINER Felipe Signorini <felipe.signorini@maestroserver.io>

RUN apk add --no-cache tini jq

ADD ./run_start_container.sh /opt/run_start_container.sh

RUN chmod +x /opt/run_start_container.sh

ENTRYPOINT ["/sbin/tini","-g","--"]
CMD ["/opt/run_start_container.sh"]