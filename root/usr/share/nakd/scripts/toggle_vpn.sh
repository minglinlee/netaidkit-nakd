#!/bin/sh

/usr/share/nakd/scripts/reset_iptables.sh # iptables flushing
LAN_LED_PATH="/sys/class/leds/alfa:yellow:lan/brightness"
WLAN_LED_PATH="/sys/class/leds/alfa:yellow:wlan/brightness"
SYS_LED_PATH="/sys/class/leds/alfa:yellow:sys/brightness"

if [ $1 = "on" ];then

    uci set firewall.@forwarding[0].enabled=0;
    uci set firewall.@forwarding[1].enabled=1;
    uci commit firewall
    /etc/init.d/firewall restart;

    > /var/log/openvpn.log
    openvpn --log-append /var/log/openvpn.log --daemon --config /nak/ovpn/current.ovpn

    /usr/share/nakd/scripts/set_stage.sh 4
    #echo "1" > $LAN_LED_PATH
    #echo "0" > $WLAN_LED_PATH
	echo "1" > $SYS_LED_PATH
elif [ $1 = "off" ]
then

    uci set firewall.@forwarding[1].enabled=0;
    uci commit firewall
    /etc/init.d/firewall restart;

    killall -9 openvpn

    /usr/share/nakd/scripts/set_stage.sh 2
    #echo "0" > $LAN_LED_PATH
    #echo "1" > $WLAN_LED_PATH
	echo "0" > $SYS_LED_PATH
fi

/etc/init.d/firewall restart
