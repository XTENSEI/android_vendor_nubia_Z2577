if [ -f "/sys/class/power_supply/battery/battery_charging_enabled" ];then
    echo 0 > /sys/class/power_supply/battery/battery_charging_enabled
fi

if [ -f "/sys/class/power_supply/interface/battery_charging_enabled" ];then
    echo 0 > /sys/class/power_supply/interface/battery_charging_enabled
fi

if [ -f "/sys/class/zte_power_supply/zte_battery/battery_charging_enabled" ];then
    echo 0 > /sys/class/zte_power_supply/zte_battery/battery_charging_enabled
fi