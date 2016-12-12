#!/bin/sh

/usr/share/nakd/scripts/reset_iptables.sh # iptables flushing
LAN_LED_PATH="/sys/class/leds/alfa:yellow:lan/brightness"
WLAN_LED_PATH="/sys/class/leds/alfa:yellow:wlan/brightness"
SYS_LED_PATH="/sys/class/leds/alfa:yellow:sys/brightness"

if [ $1 = "on" ];then
    rm /var/log/tor/notices.log
    /etc/init.d/tor start
    uci set firewall.@redirect[1].enabled=1;
    uci set firewall.@redirect[2].enabled=1;
    uci set firewall.@forwarding[0].enabled=0;
    /usr/share/nakd/scripts/set_stage.sh 3
    #echo "1" > $LAN_LED_PATH
    #echo "0" > $WLAN_LED_PATH
	echo "1" > $SYS_LED_PATH
elif [ $1 = "off" ]
then
    /etc/init.d/tor stop
    uci set firewall.@redirect[1].enabled=0;
    uci set firewall.@redirect[2].enabled=0;
    /usr/share/nakd/scripts/set_stage.sh 2
    #echo "0" > $LAN_LED_PATH
    #echo "1" > $WLAN_LED_PATH
	echo "0" > $SYS_LED_PATH
fi

uci commit;
/etc/init.d/firewall restart
