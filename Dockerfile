FROM alpine:3.23.3

ARG NAME=dropbear-bastion
ARG USER=bastion
ARG GROUP=bastion
ARG UID=102222
ARG GID=102222
# no privileges required
ENV PORT=2222

RUN set -x \
	&& addgroup -S -g ${GID} ${GROUP} \
	&& adduser -S -D -H -u ${UID} -s /bin/sh -G ${GROUP} -g "dropbear-bastion service" ${USER} \
	&& apk add --no-cache \
		dropbear \
# for license compliance
		dropbear-doc \
	&& mkdir -p /usr/local/share/${NAME}/

COPY LICENSE /usr/local/share/${NAME}/

USER ${UID}:${GID}

EXPOSE ${PORT}/tcp

VOLUME /etc/dropbear

ENTRYPOINT ["dropbear"]
CMD ["-EFRsw", "-p", "${PORT}", "-D", "/etc/dropbear", "-c", "/bin/false"]
