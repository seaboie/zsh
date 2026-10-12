mpv() {
  emulate -L zsh
  local last="${@[-1]}"
  if [[ "$last" =~ ^[0-9]+$ ]]; then
    local mins=$last
    set -- "${@[1,-2]}"
    echo "⏰ เล่น $mins นาทีแล้วปิดอัตโนมัติ"
    ( sleep $((mins*60)) && pkill -9 mpv 2>/dev/null; killall mpv 2>/dev/null ) &!
  fi
  command mpv "$@"
}
