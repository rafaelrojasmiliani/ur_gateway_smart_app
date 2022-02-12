FROM --platform=linux/arm/v7 rafa606/urroscontrol
WORKDIR /
ENV SSL_CERT_FILE=/usr/lib/ssl/certs/ca-certificates.crt
SHELL ["/bin/bash", "-c"]

# 1) Avahi configuration
# 2) entrypoint construction
RUN cat > /etc/avahi/avahi-daemon.conf << EOF\
[server]\
host-name=urrobot\
use-ipv4=yes\
enable-dbus=no\
allow-interfaces=wlan0\
deny-interfaces=eth0\
ratelimit-interval-usec=1000000\
ratelimit-burst=1000\
[wide-area]\
enable-wide-area=yes\
[publish]\
publish-hinfo=no\
publish-workstation=no\
\
[reflector]\
\
[rlimits]\
EOF
