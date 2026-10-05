#!/system/bin/sh
#[For MTK projects!!!]
#this .sh is used to test current while devices enter LPM in FTM
#how to run this .sh
#adb push ftmlpm.sh /data/
#adb shell
#cd /data
#chmod 777 ftmlpm.sh
#./ftmlpm.sh
target=`getprop sys.zftdoctor_completed`
wifi6_device=`getprop sys.wifi6.device`

echo 'lpm_tag: close wcn' >> /dev/kmsg
cmd location set-location-enabled false
cmd wifi set-wifi-enabled disabled
svc bluetooth disable
sleep 3

if [ -f "/sys/class/backlight/sprd_backlight/brightness" ];then
    if [ "$(cat /sys/class/backlight/sprd_backlight/brightness)" = "0" ];then
        echo 'lpm_tag: brightness is 0' >> /dev/kmsg
        exit 0
    fi
fi

echo 'lpm_tag: enter_lpm disable modem log' >> /dev/kmsg
cplogctl setlog modem off
if [ "$wifi6_device" != "1" ];then
    cplogctl setlog wcn off
fi
cplogctl setlog pmsh off
cplogctl setlog gnss off
cplogctl setlog agdsp off
cplogctl setlog sensor off
cplogctl disable 5mode
cplogctl disable sensor
echo 'lpm_tag: enter_lpm disable modem ' >> /dev/kmsg

echo -e "at+cfun=0\r"> /dev/stty_lte30
echo 'lpm_tag: open airplane mode' >> /dev/kmsg

settings put global airplane_mode_on 1
setprop persist.radio.airplane_mode_on 1
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
echo 'lpm_tag: disable rtc' >> /dev/kmsg

if [ -f "/sys/devices/platform/mt-rtc/rtc/rtc0/dis_rtc" ];then
    echo 1 > /sys/devices/platform/mt-rtc/rtc/rtc0/dis_rtc
fi
if [ -f "/sys/class/rtc/rtc0/irq_disable" ];then
    echo 1 > /sys/class/rtc/rtc0/irq_disable
fi

while [ "$target" != "1" ] ;do
    sleep 1
    target=`getprop sys.zftdoctor_completed`
done
echo 'lpm_tag: zftdoctor_completed' >> /dev/kmsg

if [ "$1" == "fix" ];then
    echo 'lpm_tag: unplug powerline' >> /dev/kmsg
    dumpsys battery unplug
fi

if [ -f "/sys/class/backlight/panel0-backlight/brightness" ];then
    echo 'lpm_tag: screen-off' >> /dev/kmsg
    echo 0 > /sys/class/power_supply/charger/charging_enabled
    sleep 1
elif [ "$1" == "fixture" ];then
    echo 'lpm_tag: fixture screen-off' >> /dev/kmsg
    dumpsys power no-wake-on-plug
else
    echo 'lpm_tag: screen-off' >> /dev/kmsg
fi

echo 'lpm_tag: press power key' >> /dev/kmsg
input keyevent 26

echo 'lpm_tag: release wakelock okey' >> /dev/kmsg
echo mmi > /sys/power/wake_unlock
echo PowerManagerService.Display > /sys/power/wake_unlock
echo PowerManagerService.WakeLocks > /sys/power/wake_unlock
