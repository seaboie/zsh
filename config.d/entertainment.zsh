
m4a() {
  if [ -z "$1" ]; then
    echo "Usage: m4a <Video-Url>"
    return 1
  fi

  yt-dlp -x --audio-format m4a --audio-quality 0 --embed-thumbnail --add-metadata \
  --output "/Users/krit/Music/m4a/%(title).50s.%(ext)s" \
  --ignore-errors "$@" && say "music m4a download completed"

}


# -----------------------------------------------  Download Facebook

# MP3

fbmp3() {
  if [ -z "$1" ]; then
    echo "Usage: fbmp3 <facebook-video-url>"
    return 1
  fi

  yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata \
    --output "/Users/krit/Music/audio/%(title).50s.%(ext)s" "$@" && say "Facebook music        MP3 download completed"
}

# MP4

# alias fbmp4='yt-dlp -f "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]" --merge-output-format mp4 --output "%(title)s.%(ext)s" --recode-video mp4'

fbmp4() {
  if [ -z "$1" ]; then
    echo "Usage: fbmp4 <facebook-video-url>"
    return 1
  fi

  local default_path="/Users/krit/Movies/movie"

  yt-dlp -f "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]" \
  --merge-output-format mp4 \
  --output "$default_path/%(title).50s.%(ext)s" "$@" && say "Facebook video        MP4 download completed"
   
}

# -----------------------------------------------  Download  Youtube ----------------------------------------


########### Download Youtube

# MP3

ytmp3() {
  if [ -z "$1" ]; then
    echo "Usage: ytmp3 <video-url>"
    return 1
  fi

  local default_path="/Users/krit/Music/audio"

  yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata \
    --parse-metadata "%(title)s:%(meta_title)s" \
    --output "$default_path/%(title).50s.%(ext)s" "$@" && say "Youtube download mp3 completed"
}



# MP4


ytmp4() {
  if [ -z "$1" ]; then
    echo "Usage: ytmp4 <video-url>"
    return 1
  fi

  local default_path="/Users/krit/Movies/movie"

  yt-dlp -f "bestvideo[ext=mp4][vcodec^=avc1][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4]" \
  --merge-output-format mp4  \
  --embed-thumbnail \
  --embed-subs  \
  --write-auto-subs \
  --sub-langs en  \
  --sub-format vtt  \
  --convert-subs srt \
  --restrict-filenames \
  --output "$default_path/%(title).50s [%(resolution)s].%(ext)s" \
  --no-playlist "$@"; say "Youtube download mp4 completed"
}

### 🔥 🔥 🔥 --no-playlist   download only one video not all in playlist

# -----------------------------------------------  mp4 to MOV ----------------------------------------

############## Convert mp4 to mov


mp4tomov() {
  input="$1"
  if [ -z "$input" ] || [ ! -f "$input" ]; then
    echo "Usage: converttomov <video_file>"
    return 1
  fi

  filename=$(basename "$input")
  name_no_ext="${filename%.*}"
  output="${name_no_ext}.mov"

  # Escape filename for subtitles filter (works in Zsh & Bash)
  input_escaped="${input//\'/\\\'}"

  ffmpeg -i "$input" -vf "subtitles='${input_escaped}'" -c:v libx264 -c:a aac -movflags +faststart "$output"; 
  
  say "Convert mp4 to mov for support ios devices , completed"
}



### -----------------------------  #######

alias m1="afplay '/Users/krit/Music/audio/ไม่มีทางรู้เลย.mp3'"
alias m2="afplay '/Users/krit/Music/audio/คำเชย ๆ - big & the superband (Cover by Palm).mp3'"
alias m3="afplay '/Users/krit/Music/audio/เสียงของหัวใจ.mp3'"


### -------------- Function  Play Music by  [ afplay ]---------------  #######


##  กด   n  ข้ามเพลง
##  กด   q  จบเพลง แล้วออก
##  กด   Ctr + c  : 2 ครั้ง   Exit

# playmusic ~/Music/audio                 # เล่นวนไม่จำกัด
# playmusic ~/Music/audio 30              # เล่น 30 นาที
# playmusic ~/Music/audio 30 --sleep      # 30 นาที + sleep
# playmusic ~/Music/audio 30 --shutdown   # 30 นาที + shutdown




playmusic() {
    if [ -z "$1" ]; then
        echo "使用方法: playmusic <โฟลเดอร์> [นาที] [--sleep|--shutdown]"
        echo "ตัวอย่าง: playmusic ~/Music/audio 30 --sleep"
        return 1
    fi

    local dir="${1/#\~/$HOME}"
    local minutes="${2:-0}"
    local action="${3:-}"
    local end_time=0
    local afplay_pid=""
    local force_quit=0
    local quit_after_song=0

    if [ ! -d "$dir" ]; then
        echo "❌ ไม่พบโฟลเดอร์: $dir"
        return 1
    fi

    if [ "$minutes" -gt 0 ]; then
        end_time=$(( $(date +%s) + minutes * 60 ))
        echo "🎵 กำลังเล่นเพลงจาก: $dir"
        echo "⏰ จะหยุดใน $minutes นาที"
        [ -n "$action" ] && echo "💤 หลังจากนั้นจะ $action"
    else
        echo "🎵 กำลังเล่นเพลงจาก: $dir"
    fi
    echo "   ⌨️  n = ข้าม | q = เล่นจบเพลงนี้แล้วออก | Ctrl+C = ออกทันที"
    echo ""

    # ปิด canonical mode เพื่อรับ 1 คีย์
    local old_stty=$(stty -g </dev/tty 2>/dev/null)
    stty -icanon -echo min 0 time 1 </dev/tty 2>/dev/null

    # restore tty เมื่อออก
    _pm_restore() {
        stty "$old_stty" </dev/tty 2>/dev/null
    }

    # trap Ctrl+C: ตั้ง flag แล้ว loop จะเช็คเอง
    trap 'force_quit=1' INT TERM

    while true; do
        while IFS= read -r f; do
            # ออกทันทีถ้ากด Ctrl+C
            if [ "$force_quit" -eq 1 ]; then
                _pm_restore
                echo ""
                echo "⏹  ออกแล้ว"
                return 0
            fi

            # เช็คเวลา
            if [ "$end_time" -gt 0 ] && [ "$(date +%s)" -ge "$end_time" ]; then
                _pm_restore
                echo "⏰ ครบเวลาแล้ว"
                do_action "$action"
                return 0
            fi

            echo "▶️  $(basename "$f")"
            afplay "$f" < /dev/null &
            afplay_pid=$!

            local skip=0

            # รอเพลงเล่น + รับคีย์
            while kill -0 "$afplay_pid" 2>/dev/null; do
                # ออกทันที
                if [ "$force_quit" -eq 1 ]; then
                    kill "$afplay_pid" 2>/dev/null
                    wait "$afplay_pid" 2>/dev/null
                    _pm_restore
                    echo ""
                    echo "⏹  ออกแล้ว"
                    return 0
                fi

                # อ่านคีย์ (timeout 0.1 วิ)
                local key=""
                IFS= read -r -k 1 -t 0.1 key </dev/tty 2>/dev/null

                case "$key" in
                    n|N)
                        echo ""
                        echo "⏭  ข้าม"
                        kill "$afplay_pid" 2>/dev/null
                        skip=1
                        break
                        ;;
                    q|Q)
                        if [ "$quit_after_song" -eq 0 ]; then
                            quit_after_song=1
                            echo ""
                            echo "⏹  จะออกหลังเพลงนี้จบ (Ctrl+C = ออกทันที)"
                        fi
                        ;;
                esac

                # เช็คเวลา
                if [ "$end_time" -gt 0 ] && [ "$(date +%s)" -ge "$end_time" ]; then
                    kill "$afplay_pid" 2>/dev/null
                    wait "$afplay_pid" 2>/dev/null
                    _pm_restore
                    echo "⏰ ครบเวลาแล้ว"
                    do_action "$action"
                    return 0
                fi
            done

            wait "$afplay_pid" 2>/dev/null

            # เพลงจบ — ถ้ากด q ไว้ ให้ออก
            if [ "$quit_after_song" -eq 1 ]; then
                _pm_restore
                echo "✅ เพลงจบแล้ว ออก"
                return 0
            fi

            [ "$skip" -eq 1 ] && continue
        done < <(find "$dir" -name "*.mp3" | sort -R)
    done
}

# ฟังก์ชันช่วย sleep/shutdown
do_action() {
    case "$1" in
        --sleep)
            echo "💤 พักเครื่องใน 10 วินาที..."
            sleep 5
            pmset sleepnow
            ;;
        --shutdown)
            echo "🔌 ปิดเครื่องใน 60 วินาที..."
            sudo shutdown -h +1
            ;;
        *)
            echo "✅ เสร็จแล้ว"
            ;;
    esac
}





# playmusic() {
#     if [ -z "$1" ]; then
#         echo "使用方法: playmusic <โฟลเดอร์> [นาที] [--sleep|--shutdown]"
#         return 1
#     fi

#     local dir="${1/#\~/$HOME}"
#     local minutes="${2:-0}"
#     local action="${3:-}"
#     local end_time=0
#     local afplay_pid=""

#     if [ ! -d "$dir" ]; then
#         echo "❌ ไม่พบโฟลเดอร์: $dir"
#         return 1
#     fi

#     if [ "$minutes" -gt 0 ]; then
#         end_time=$(( $(date +%s) + minutes * 60 ))
#         echo "🎵 กำลังเล่นเพลงจาก: $dir"
#         echo "⏰ จะหยุดใน $minutes นาที"
#         [ -n "$action" ] && echo "💤 หลังจากนั้นจะ $action"
#     else
#         echo "🎵 กำลังเล่นเพลงจาก: $dir"
#     fi
#     echo "   ⌨️  n = ข้ามเพลง | q = เล่นจบเพลงนี้แล้วออก | Ctrl+C = ออกทันที"
#     echo ""

#     # 🎯 ปิด canonical mode
#     local old_stty=$(stty -g </dev/tty 2>/dev/null)
#     stty -icanon -echo min 0 time 1 </dev/tty 2>/dev/null

#     # 🎯 trap: Ctrl+C ออกทันที
#     cleanup() {
#         stty "$old_stty" </dev/tty 2>/dev/null
#         [ -n "$afplay_pid" ] && kill "$afplay_pid" 2>/dev/null
#         pkill -P $$ afplay 2>/dev/null
#         echo ""
#         echo "⏹  ออกแล้ว"
#         # ใช้ exit จาก function ไม่ได้ ต้อง return
#         return 0
#     }
#     trap 'cleanup; return 0' INT

#     local quit_after_song=0
#     local force_quit=0

#     while true; do
#         while IFS= read -r f; do
#             [ "$force_quit" -eq 1 ] && { stty "$old_stty" </dev/tty 2>/dev/null; return 0; }

#             if [ "$end_time" -gt 0 ] && [ "$(date +%s)" -ge "$end_time" ]; then
#                 echo "⏰ ครบเวลาแล้ว"
#                 stty "$old_stty" </dev/tty 2>/dev/null
#                 do_action "$action"
#                 return 0
#             fi

#             echo "▶️  $(basename "$f")"
#             afplay "$f" < /dev/null &
#             afplay_pid=$!

#             local skip=0

#             while kill -0 "$afplay_pid" 2>/dev/null; do
#                 local key=""
#                 IFS= read -r -k 1 -t 0.1 key </dev/tty 2>/dev/null

#                 case "$key" in
#                     n|N)
#                         echo ""
#                         echo "⏭  ข้าม"
#                         kill "$afplay_pid" 2>/dev/null
#                         skip=1
#                         break
#                         ;;
#                     q|Q)
#                         if [ "$quit_after_song" -eq 0 ]; then
#                             quit_after_song=1
#                             echo ""
#                             echo "⏹  จะออกหลังเพลงนี้จบ (กด Ctrl+C เพื่อออกทันที)"
#                         fi
#                         ;;
#                 esac

#                 if [ "$end_time" -gt 0 ] && [ "$(date +%s)" -ge "$end_time" ]; then
#                     kill "$afplay_pid" 2>/dev/null
#                     wait "$afplay_pid" 2>/dev/null
#                     echo "⏰ ครบเวลาแล้ว"
#                     stty "$old_stty" </dev/tty 2>/dev/null
#                     do_action "$action"
#                     return 0
#                 fi
#             done

#             wait "$afplay_pid" 2>/dev/null

#             if [ "$quit_after_song" -eq 1 ]; then
#                 echo "✅ เพลงจบแล้ว ออก"
#                 stty "$old_stty" </dev/tty 2>/dev/null
#                 return 0
#             fi

#             [ "$skip" -eq 1 ] && continue
#         done < <(find "$dir" -name "*.mp3" | sort -R)
#     done
# }