
# เล่นเพลง

mpv() {
  emulate -L zsh
  local last="${@[-1]}"
  
  # ถ้า argument สุดท้ายเป็นตัวเลข = ตั้งเวลา
  if [[ "$last" =~ ^[0-9]+$ ]]; then
    local mins=$last
    set -- "${@[1,-2]}"
    echo "⏰ เล่น $mins นาทีแล้วปิดแค่จอนี้"
    
    command mpv "$@" &
    local pid=$!
    
    (
      sleep $((mins*60))
      echo "\n💤 หมดเวลา $mins นาทีแล้ว ปิดจอ $pid"
      kill $pid 2>/dev/null
      sleep 1.5
      tput cnorm 2>/dev/null
      echo -ne "\e[?25h"
      # ถ้ายังดื้อ ค่อยฆ่าแรงแค่ตัวนี้
      if kill -0 $pid 2>/dev/null; then
        kill -9 $pid 2>/dev/null
        tput cnorm 2>/dev/null
      fi
    ) &!

    wait $pid
  else
    # ไม่มีตัวเลข = ใช้งานปกติ
    command mpv "$@"
  fi
  
  tput cnorm 2>/dev/null
  echo -ne "\e[?25h"
}
