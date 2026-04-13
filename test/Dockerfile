FROM debian:stable

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		openssh-client

COPY --chmod=u=rwX,go= .ssh /root/.ssh
COPY --chmod=+x tests.sh /root/

CMD ["/root/tests.sh"]
