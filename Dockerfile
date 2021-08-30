FROM ubuntu:16.04
ENV PROXY_VER=0.8.11
ARG proxy=''

RUN apt-get update && apt-get install -y curl
RUN apt -y install fail2ban software-properties-common
RUN apt install -y build-essential libevent-dev libssl-dev

RUN apt-get -q update &&\
	DEBIAN_FRONTEND=noninteractive &&\
	apt-get -qy --force-yes dist-upgrade &&\
	# Install req software
	apt-get install -qy --force-yes  build-essential libevent-dev libssl-dev wget &&\
	# Install 3proxy
	wget https://github.com/z3APA3A/3proxy/archive/${PROXY_VER}.tar.gz &&\
	tar xzfv ${PROXY_VER}.tar.gz -C /tmp &&\
	# Enable anonymous mode
	echo '#define ANONYMOUS 1' >> /tmp/3proxy-${PROXY_VER}/src/3proxy.h &&\
	make -C /tmp/3proxy-${PROXY_VER} -f Makefile.Linux &&\
	make -C /tmp/3proxy-${PROXY_VER} -f Makefile.Linux install &&\
	rm ${PROXY_VER}.tar.gz &&\
	# For log to stdout
	ln -sf /dev/stdout /var/log/3proxy.log &&\
	# Clean
	apt-get purge -y --auto-remove build-essential wget &&\
	apt-get clean &&\
	rm -rf /var/lib/apt/lists/* /tmp/*

COPY 3proxy.cfg /etc/3proxy/3proxy.cfg
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
# Ports
EXPOSE 8080 3128

STOPSIGNAL SIGTERM

ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD [ "/usr/local/bin/3proxy", "/etc/3proxy/3proxy.cfg" ]
CMD ["start_proxy"]
