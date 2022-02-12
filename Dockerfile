FROM --platform=linux/arm/v7 rafa606/urroscontrol
WORKDIR /
ENV SSL_CERT_FILE=/usr/lib/ssl/certs/ca-certificates.crt
SHELL ["/bin/bash", "-c"]

# 1) Avahi configuration
# 2) entrypoint construction
RUN echo $'\
[server]\n\
host-name=urrobot\n\
use-ipv4=yes\n\
enable-dbus=no\n\
allow-interfaces=wlan0\n\
deny-interfaces=eth0\n\
ratelimit-interval-usec=1000000\n\
ratelimit-burst=1000\n\
[wide-area]\n\
enable-wide-area=yes\n\
[publish]\n\
publish-hinfo=no\n\
publish-workstation=no\n\
\n\
[reflector]\n\
\n\
[rlimits]\n' > /etc/avahi/avahi-daemon.conf
