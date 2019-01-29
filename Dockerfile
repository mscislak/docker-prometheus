FROM alpine:3.8
LABEL maintainer="Maros Scislak <maros.scislak@gmail.com>"

RUN apk --no-cache add \
		ca-certificates \
		curl

ENV PROMETHEUS_VERSION="2.7.0" \
	PROMETHEUS_CHECKSUM="a4d6674c3e81d85f1063818daecfe7ae14ce61d3524f32480530fda48b2a1e12"

RUN PKG_NAME=prometheus-${PROMETHEUS_VERSION}.linux-armv7 && cd /tmp \
	&& curl -sSL -O https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PKG_NAME}.tar.gz \
	&& echo "${PROMETHEUS_CHECKSUM} ${PKG_NAME}.tar.gz" | sha256sum -c \
	&& tar -xf ${PKG_NAME}.tar.gz \
	&& mkdir /etc/prometheus \
	&& mv ${PKG_NAME}/consoles /etc/prometheus \
	&& mv ${PKG_NAME}/console_libraries /etc/prometheus \
	&& mv ${PKG_NAME}/prometheus.yml /etc/prometheus \
	&& mv ${PKG_NAME}/prometheus /usr/local/bin/ \
	&& mv ${PKG_NAME}/promtool /usr/local/bin/ \
	&& mkdir -p /prometheus \
    && chown -R nobody:nogroup /etc/prometheus /prometheus \
    && rm -rf /tmp/*

USER       nobody
EXPOSE     9090
VOLUME     [ "/var/lib/prometheus" ]
WORKDIR    /var/lib/prometheus
ENTRYPOINT [ "/usr/local/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/var/lib/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
