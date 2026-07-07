#!/bin/bash

NOTIF_ID=9999
LAST_NOTIF_TIME=0
INTERVAL=120 # 2 phút

while true; do
    # Tìm đường dẫn pin
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
        BAT_PATH="/sys/class/power_supply/BAT0"
    else
        BAT_PATH="/sys/class/power_supply/BAT1"
    fi

    BATTERY_LEVEL=$(cat "$BAT_PATH/capacity" 2>/dev/null)
    BATTERY_STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)
    CURRENT_TIME=$(date +%s)

    # Chỉ hoạt động khi pin <= 20% VÀ đang xả
    if [ "$BATTERY_LEVEL" -le 20 ] && [ "$BATTERY_STATUS" = "Discharging" ]; then
        
        TIME_DIFF=$((CURRENT_TIME - LAST_NOTIF_TIME))
        
        # Gửi thông báo lần đầu hoặc sau mỗi 2 phút
        if [ "$TIME_DIFF" -ge "$INTERVAL" ]; then
            notify-send -r "$NOTIF_ID" -u critical "WARNING: LOW BATTERY" "Capacity is ${BATTERY_LEVEL}%. Please plug in the charger!"
            LAST_NOTIF_TIME=$CURRENT_TIME
        fi
        
    else
        # BỎ HOÀN TOÀN lệnh notify-send ở đây
        # Khi pin trên 20%, script chỉ đơn giản là không làm gì cả
        # Reset thời gian để khi pin tụt xuống 20% lần tới nó sẽ báo ngay
        LAST_NOTIF_TIME=0
    fi

    sleep 30
done
