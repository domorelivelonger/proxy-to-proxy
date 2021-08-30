#!/bin/bash

if [ "$1" = "start_proxy" ]; then
    if [ ! -f /etc/3proxy/3proxy.cfg ]; then
        if [ -z "$proxy" ]; then
            echo >&2 'error: proxy is uninitialized, variables is not specified '
            echo >&2 '  You need to specify $proxy'
            exit 1
        fi
        mv /etc/3proxy/3proxy.cfg /etc/3proxy/3proxy.cfg.old
        touch /etc/3proxy/3proxy.cfg
        echo "nserver 1.1.1.1" >> /etc/3proxy/3proxy.cfg
        echo "nserver 8.8.8.8" >> /etc/3proxy/3proxy.cfg
        echo "nserver 8.8.4.4" >> /etc/3proxy/3proxy.cfg
        echo "nscache 65536" >> /etc/3proxy/3proxy.cfg
        echo "timeouts 1 5 30 60 180 1800 15 60" >> /etc/3proxy/3proxy.cfg
        echo "log /var/log/3proxy.log" >> /etc/3proxy/3proxy.cfg
        echo 'logformat "- +_L%t.%.  %N.%p %E %U %C:%c %R:%r %O %I %h %T"' >> /etc/3proxy/3proxy.cfg
        echo "daemon" >> /etc/3proxy/3proxy.cfg
        echo "maxconn 1000" >> /etc/3proxy/3proxy.cfg
        echo "auth iponly" >> /etc/3proxy/3proxy.cfg
        echo "allow *" >> /etc/3proxy/3proxy.cfg
        echo "parent 1000 $proxy" >> /etc/3proxy/3proxy.cfg
        echo "proxy -p3128" >> /etc/3proxy/3proxy.cfg
        echo "flush" >> /etc/3proxy/3proxy.cfg
    fi

        /usr/local/bin/3proxy /etc/3proxy/3proxy.cfg
else
	exec "$@"
fi
