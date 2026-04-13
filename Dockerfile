FROM alpine:3.23.3

ARG NAME=dropbear-bastion
ARG USER=bastion
ARG GROUP=bastion
ARG UID=102222
ARG GID=102222

RUN set -x \
	&& addgroup -S -g ${GID} ${GROUP} \
	&& adduser -S -D -H -h / -u ${UID} -s /bin/sh -G ${GROUP} -g "dropbear-bastion service" ${USER} \
	&& apk add --no-cache \
		dropbear \
# for license compliance
		dropbear-doc \
	&& mkdir -p /usr/local/share/${NAME}/

COPY LICENSE /usr/local/share/${NAME}/

USER ${UID}:${GID}

# no privileges required
EXPOSE 2222/tcp

VOLUME /etc/dropbear

ENTRYPOINT ["dropbear"]
CMD ["-EFRsw", "-p", "2222", "-D", "/etc/dropbear", "-c", "/bin/false"]
