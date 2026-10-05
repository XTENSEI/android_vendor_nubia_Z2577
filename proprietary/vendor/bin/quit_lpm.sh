#!/system/bin/sh
if [ -f "/sys/class/rtc/rtc0/irq_disable" ];then
    echo 0 > /sys/class/rtc/rtc0/irq_disable
fi

if [ "$1" == "fix" ];then
    dumpsys battery reset
    echo 'lpm_tag: quit_lpm plug powerline' >> /dev/kmsg
fi

echo on > /sys/power/state;

settings put global airplane_mode_on 0
setprop persist.radio.airplane_mode_on 0
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false
echo 'lpm_tag: quit_lpm close airplane modem' >> /dev/kmsg

svc nfc enable

cmd location set-location-enabled true
cmd wifi set-wifi-enabled enabled
svc bluetooth enabled

cplogctl enable wcn
cplogctl enable pmsh
cplogctl enable gnss
cplogctl enable 5mode
cplogctl enable sensor
