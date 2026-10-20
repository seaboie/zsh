
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





### -----------------------------  #######

alias m1="afplay '/Users/krit/Music/audio/ไม่มีทางรู้เลย.mp3'"
alias m2="afplay '/Users/krit/Music/audio/คำเชย ๆ - big & the superband (Cover by Palm).mp3'"
alias m3="afplay '/Users/krit/Music/audio/เสียงของหัวใจ.mp3'"



############################################################################################################
############################################################################################################


##################################################.           Download   Youtube   ##########################################################

# 1. เพลงเดียว
alias yta='yt-dlp --cookies-from-browser chrome -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --no-playlist -P ~/Music -o "%(title)s [%(id)s].%(ext)s"'

# 2. แยกเพลงจากอัลบัมทั้งก้อน (chapter)
alias ytasplitchapter='yt-dlp --cookies-from-browser chrome -x --audio-format mp3 --audio-quality 0 --split-chapters --embed-thumbnail -P ~/Music -o "%(title)s.%(ext)s" -o "chapter:%(title)s/%(section_number)02d - %(section_title)s.%(ext)s"'

# 3. ทั้ง playlist
alias ytaplaylist='yt-dlp --cookies-from-browser chrome -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --yes-playlist -P ~/Music -o "%(playlist_title)s/%(playlist_index)02d - %(title)s.%(ext)s"'

# 4. เลือกเพลงใน playlist
ytapick() {
  # ytapick "1,5,9" "ลิงก์" 
  # ytapick "1-3,9" "ลิงก์"
  # ytapick "5:" "ลิงก์"
  # ytapick ":10"
  local items="$1"
  shift
  yt-dlp --cookies-from-browser chrome -x --audio-format mp3 --audio-quality 0 \
    --embed-metadata --embed-thumbnail --yes-playlist \
    --playlist-items "$items" \
    -P ~/Music \
    -o "%(playlist_title)s/%(playlist_index)02d - %(title)s.%(ext)s" \
    "$@"
}


############################################################################################################
############################################################################################################

converttomp4slowly() {
  # วิธีใช้: converttomp4slowly input.mp4  [output.mp4]  [speed 0.5-1.0]  [quality 1-100]
  if [[ -z "$1" ]]; then
    echo "วิธีใช้ 1: converttomp4slowly input.mp4 "
    echo "วิธีใช้2 ( ระบุ อาร์กิวเมนต์ เพิ่ม ): converttomp4slowly input.mp4 [output.mp4] [speed 0.5-1.0] [quality 1-100] "
    echo "speed : default = 0.75"
    echo "quality : default = 60 >> ค่ายิ่งมาก ภาพยิ่งชัด"
    return 1
  fi

  local input="$1"
  local output="${2:-${input:r}_hevc.mp4}"
  local speed="${3:-0.75}"
  local quality="${4:-60}"
  

  if [[ ! -f "$input" ]]; then
    echo "ไม่พบไฟล์: $input"
    return 1
  fi

  # เช็คว่ามีแทร็กเสียงไหม
  if ffprobe -v error -select_streams a -show_entries stream=index \
       -of csv=p=0 "$input" | grep -q .; then
    ffmpeg -n -i "$input" \
      -filter_complex "[0:v]setpts=PTS/${speed}[v];[0:a]atempo=${speed}[a]" \
      -map "[v]" -map "[a]" \
      -c:v hevc_videotoolbox -q:v "$quality" -tag:v hvc1 \
      -c:a aac -b:a 192k \
      -movflags +faststart \
      "$output"
  else
    ffmpeg -n -i "$input" \
      -filter:v "setpts=PTS/${speed}" -an \
      -c:v hevc_videotoolbox -q:v "$quality" -tag:v hvc1 \
      -movflags +faststart \
      "$output"
  fi
}

##################################################################                Convert to    MP4
converttomp4() {
  #    วิธีใช้: converttomp4 input.mov                     # ได้ input_hevc.mp4 คุณภาพ 60
  #          converttomp4 input.mov output.mp4       # ตั้งชื่อผลลัพธ์เอง
  #          converttomp4 input.mov output.mp4 70    # ค่า Default quality = 60
  if [[ -z "$1" ]]; then
    echo "วิธีใช้: converttomp4 input.MOV [output.mp4] [quality 1-100]"
    echo ""
    echo "      converttomp4 input.webm output.mp4"
    echo ""
    echo "      converttomp4 input.mp4 output.mp4 80"
    return 1
  fi

  local input="$1"
  local output="${2:-${input:r}_hevc.mp4}"
  local quality="${3:-60}"

  if [[ ! -f "$input" ]]; then
    echo "ไม่พบไฟล์: $input"
    return 1
  fi

  ffmpeg -n -i "$input" \
    -c:v hevc_videotoolbox -q:v "$quality" -tag:v hvc1 \
    -c:a aac -b:a 192k \
    -movflags +faststart \
    "$output"
}


#####################################################
#################################################################.   Audio  :::  Cut song in album


ytasplitalbum() {
  local input="$1" expected="$2" go="$3"
  # local noise="${SPLIT_NOISE:--30dB}" dur="${SPLIT_DUR:-0.2}"
  local noise="${SPLIT_NOISE:--35dB}" dur="${SPLIT_DUR:-0.1}"

  if [[ -z "$input" || -z "$expected" ]]; then
    echo ""
    echo "วิธีใช้:"
    echo ""
    echo "Run ::: ytasplitalbum ไฟล์เพลง.mp3 จำนวนเพลง :::   ก่อน เพื่อเช็คว่าจำนวนเพลง ครบไหม"
    echo "ถ้าจำนวนเพลงครบ :::"
    echo "Run :::  ytasplitalbum ไฟล์.mp3 จำนวนเพลง [-go]"
    echo "================================="
    echo ""
    echo ""
    echo "ถ้าจำนวนเพลง ไม่ครบ ต้องมาปรับ ค่า :::"
    echo "Default : ปรับความไวได้: SPLIT_NOISE=-35dB SPLIT_DUR=0.5 splitalbum ..."
    echo ""
    echo "SPLIT_NOISE : ค่า ยิ่งใกล็ 0 ยิ่งดังมากๆๆๆ"
    echo "SPLIT_NOISE : -25dB = เสียงค่อย ๆ นิดหน่อยก็ถือว่าเงียบแล้ว ( ดัง )"
    echo "SPLIT_NOISE : -50dB = ต้องเงียบสนิทจริง ๆ ถึงจะนับ ( เงียบ )"
    echo ""
    echo "SPLIT_DUR   : 0.2 = เงียบแค่ 0.2 วินาทีก็นับ ( เงียบ )"
    echo "SPLIT_DUR   : 1.0 = ต้องเงียบนาน 1 วินาทีขึ้นไปถึงจะนับ ( เงียบ นาน นาน นาน )"
    echo ""
    echo "              จำนวน เพลงไม่ครบ"
    echo "     เช่น อัลบั้มมี 12 เพลง แต่ตรวจเจอแค่ 9"
    echo "เพิ่ม SPLIT_NOISE ให้ใกล้ 0 (เช่น -35dB เป็น -25dB)"
    echo "ลด SPLIT_DUR (เช่น 0.5 เป็น 0.2)"
    echo "ตัวอย่าง ::: -35db กับ 0.5  ==> ได้จำนวนเพลง ไม่ครบ น้อยกว่า ==> -30db กับ 0.2"
    echo ""
    echo "ดู Path ให้ตรงกันด้วยเพราะ folder เพลงที่ตัดแล้วจะไปอยู่ที่ตำแหน่งที่ run command"
    return 1
  fi
  [[ -f "$input" ]] || { echo "ไม่พบไฟล์: $input"; return 1; }

  local total
  total=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$input")

  local -a times
  times=(0 ${(f)"$(ffmpeg -nostats -i "$input" -af silencedetect=noise=$noise:d=$dur -f null - 2>&1 \
    | awk -v t="$total" '/silence_start/{s=$5} /silence_end/{m=(s+$5)/2; if(m>30 && m<t-10) print m}')"})

  local n=${#times} i num sec
  echo "ตรวจเจอ $n เพลง (ต้องการ $expected)"
  for i in {1..$n}; do
    sec=${times[i]%.*}
    printf "  %02d  เริ่มที่ %d:%02d\n" $i $(( sec / 60 )) $(( sec % 60 ))
  done

  if (( n != expected )); then
    echo "จำนวนไม่ตรง ยังไม่ตัด ลองปรับ SPLIT_NOISE / SPLIT_DUR แล้วรันตรวจอีกครั้ง"
    return 1
  fi
  if [[ "$go" != "-go" ]]; then
    echo "จำนวนตรงแล้ว ถ้าโอเคให้รันซ้ำพร้อม -go เพื่อตัดจริง"
    return 0
  fi

  local base="${input:t:r}"
  local out="${base}_tracks"
  mkdir -p "$out"
  local cover="$out/.cover.jpg"
  ffmpeg -nostats -loglevel error -y -i "$input" -an -frames:v 1 "$cover" 2>/dev/null
  local -a cmap range
  if [[ -s "$cover" ]]; then
    cmap=(-i "$cover" -map 0:a -map 1:v -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)")
    echo "พบปกอัลบั้ม จะแนบเข้าทุกเพลง"
  else
    cmap=(-map 0:a -c copy -id3v2_version 3)
    echo "ไม่พบปกอัลบั้มในไฟล์ต้นฉบับ จะตัดเฉพาะเสียง"
  fi

  for i in {1..$n}; do
    num=$(printf "%02d" $i)
    range=(-ss ${times[i]})
    (( i < n )) && range+=(-t $(( times[i+1] - times[i] )))
    ffmpeg -nostats -loglevel error -y "${range[@]}" -i "$input" "${cmap[@]}" \
      -metadata track="$i/$n" "$out/$num - Track $num.mp3"
  done

  rm -f "$cover"
  echo "เสร็จแล้ว: $n ไฟล์ อยู่ในโฟลเดอร์ $out/"
}