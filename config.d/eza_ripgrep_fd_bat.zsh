###################################################
# eza.zsh - ปรับสีให้ Terminal
###################################################

# --- 1. ตั้งค่าพื้นฐาน Terminal ---
export CLICOLOR=1
export TERM=xterm-256color

# --- 2. Starship Prompt ---
autoload -Uz compinit && compinit
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

function starship_on() {
  eval "$(starship init zsh)"
}
function starship_off() {
    unfunction prompt_starship_setup 2>/dev/null
    autoload -U promptinit; promptinit
    PROMPT='%F{magenta}%n@%m%f %~ %# '
    # prompt adam1
}
starship_off 
# starship_on

# --- 3. Alias หลัก ---
alias ls='eza --color=always --icons=always'
alias cat='bat --style=plain'
alias grep='rg --color=always'
alias find='fd'

# --- 4. Auto Suggestion & Syntax Highlighting ---
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 5. Git Delta ---
git config --global core.pager delta 2>/dev/null
git config --global interactive.diffFilter "delta --color-only" 2>/dev/null
git config --global delta.navigate true 2>/dev/null

# --- 6. Function ส่วนตัว ---
rgc() {
  command rg --color=always -n "$@" | perl -pe 's/=(.*)/=\e[1;90m$1\e[0m/g'
}

# --- 7. env มีสี  - ใช้ grc ย้อมสีให้ ---
alias env='grc --colour=auto /usr/bin/env'

# --- 8. Eza ---  ls -l
################################################################ Install:  EZA  :  ` brew install eza `
########## --- 8.1.0 Install:         ` brew install vivid `       THEME สีสำหรับ File lists


########## อันนี้คุมชื่อไฟล์ -     เปลี่ยนสี ไฟล์.     vivid
### ดูรายชื่อ Theme ทั้งหมด :    ` vivid themes `
# export LS_COLORS="$(vivid generate tokyonight-night)"       # Set Theme
# export LS_COLORS="$(vivid generate catppuccin-macchiato)"     # Set Theme
# export LS_COLORS="$(vivid generate solarized-dark)"         # Set Theme
# export LS_COLORS="$(vivid generate cyberdream-light)"         # Set Theme
export LS_COLORS="$(vivid generate tokyonight-moon)"         # Set Theme

# อันนี้คุมคอลัมน์อื่นๆ ของ eza - เพิ่มอันนี้เข้าไป
export EZA_COLORS="\
da=2;36:\
uu=0;37:\
uR=1;31:\
gu=0;37:\
sn=1;32:\
sb=0;32:\
ur=1;33:\
uw=1;31:\
ux=1;32:\
"