FROM --platform=linux/arm/v7 rafa606/urroscontrol
WORKDIR /
ENV SSL_CERT_FILE=/usr/lib/ssl/certs/ca-certificates.crt
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
        vim screen libnss-mdns && \
     echo $'\
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
[rlimits]\n' > /etc/avahi/avahi-daemon.conf && \
    echo $'\
#!/bin/bash\n\
main(){\n\
service avahi-daemon restart\n\
export ROS_MASTER_URI=http://smart_app.local:11311\n\
export ROS_IP=urrobot.local\n\
source /opt/ros/noetic/setup.bash\n\
roslaunch --wait ur_calibration calibration_correction.launch \\\n\
            robot_ip:=192.169.1.2 target_filename:=/calibration.yaml \n\
bash \n\
}\n\
main $@' > /entrypoint.bash
ENTRYPOINT ["bash", "/entrypoint.bash"]
