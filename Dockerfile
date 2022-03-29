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
[rlimits]\n' > /etc/avahi/avahi-daemon.conf \
    && echo source /opt/ros/noetic/setup.bash >> /etc/bash.bashrc \
    && echo export ROS_MASTER_URI=http://smart_app.local:11311 >> /etc/bash.bashrc \
    && echo export ROS_IP=urrobot.local >> /etc/bash.bashrc \
    && echo $'\
#!/bin/bash\n\
main(){\n\
service ssh start\n\
service avahi-daemon restart\n\
sleep 0.5\n\
roslaunch --wait ur_calibration calibration_correction.launch \\\n\
            robot_ip:=192.169.1.2 target_filename:=/calibration.yaml \n\
export ROS_NAMESPACE=/smart_app/ur \n\
screen -S ur_control -d -m roslaunch \\\n\
            ur_robot_driver ur3_bringup.launch \\\n\
            robot_ip:=192.169.1.2 kinematics_config:=/calibration.yaml\\\n\
            controllers:=\'joint_state_controller pos_joint_traj_controller\'\\\n\
            stopped_controllers:=\'scaled_pos_joint_traj_controller\'\n\
}\n\
main $@' > /entrypoint.bash
ENTRYPOINT ["bash", "/entrypoint.bash"]
