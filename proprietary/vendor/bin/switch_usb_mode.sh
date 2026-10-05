if [ -f "/sys/module/zte_misc/parameters/qc3dp_sleep_mode" ];then
    echo 1 > /sys/module/zte_misc/parameters/qc3dp_sleep_mode
    echo 'lpm_tag: let WT6670F charge type detect ic enter lpm' >> /dev/kmsg
fi

if [ -f "/sys/class/power_supply/usb/lpm_usb_discon" ];then
    echo 0 > /sys/class/power_supply/usb/lpm_usb_discon
fi


if [ -f "/sys/class/zte_power_supply/zte_usb/lpm_usb_discon" ];then
    echo 0 > /sys/class/zte_power_supply/zte_usb/lpm_usb_discon
fi

echo 'lpm_tag: disconect the usb port for enter lpm test ' >> /dev/kmsg
