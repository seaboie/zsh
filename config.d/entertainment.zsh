
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
alias yta='yt-dlp --cookies-from-browser chrome -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --no-playlist -P ~/Music -o "%(title)s.%(ext)s"'

# 2. แยกเพลงจากอัลบัมทั้งก้อน (chapter)
alias ytasplit='yt-dlp --cookies-from-browser chrome -x --audio-format mp3 --audio-quality 0 --split-chapters --embed-thumbnail -P ~/Music -o "%(title)s.%(ext)s" -o "chapter:%(title)s/%(section_number)02d - %(section_title)s.%(ext)s"'

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
    echo "วิธีใช้: converttomp4 input [output.mp4] [quality 1-100]"
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


convert() {

  local input="$1"
  local output="${2:-${input:r}_hevc.mp4}"
  local quality="${3:-60}"

  if [[ -z input ]]; then
    echo "🔥 Oops !!!!!"
    echo "quality"P
    echo " ต้องมี input 1 file name"
    return 1
  fi




}