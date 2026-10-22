###################################################
###########################################.      ปรับสี  ให้ Terminal : EZA

### 1. ติดตั้งโปรแกรม
##### brew install starship eza bat git-delta jq zsh-syntax-highlighting zsh-autosuggestions

### 2. ติดตั้งฟอนต์ไอคอน
##### brew install --cask font-jetbrains-mono-nerd-font

### 3. ติดตั้ง iTerm2 และตั้งค่า
##### brew install --cask iterm2




##################################################### Alias สำหรับตอน ติดตั้ง  EZA (ezs)
### สร้าง alias
# alias ls='eza --icons=always --color=always'
# alias ll='eza -l --icons --git --group-directories-first --color=always'
# alias cat='bat --paging=never'


# alias lsd='eza -l --only-dirs --icons=always --color=always --group-directories-first' # ดูแค่โฟลเดอร์
# alias lsf='eza -l --only-files -s modified -r --icons=always --color=always' # ดูแค่ไฟล์


############.        Function  

# lst - ดูไฟล์ล่าสุดแบบมีสี+icon เสมอ
# ใช้: lst | lst 10 | lst mp4 | lst .txt 20 | lst --size | lst --no-group

# lst() {
#   # --- HELP สี ---
#   if [[ "${1:l}" == "-h" || "${1:l}" == "--help" || "${1:l}" == "help" ]]; then
#     echo -e "\e[1;36mUSAGE: lst [ตัวเลือก] [นามสกุล/จำนวน]\e[0m"
#     echo ""
#     echo -e "\e[1;33mตัวอย่าง:\e[0m"
#     echo -e "  \e[36mlst\e[0m              \e[90m# 4 ไฟล์ล่าสุด (default)\e[0m"
#     echo -e "  \e[36mlst 10\e[0m           \e[90m# 10 ไฟล์ล่าสุด\e[0m"
#     echo -e "  \e[36mlst mp4\e[0m          \e[90m# mp4 ล่าสุด\e[0m"
#     echo -e "  \e[36mlst folder\e[0m       \e[90m# เอาโฟลเดอร์ขึ้นก่อน\e[0m"
#     echo -e "  \e[36mlst folder mp4\e[0m  \e[90m# mp4 ล่าสุด + โฟลเดอร์ขึ้นก่อน\e[0m"
#     echo -e "  \e[36mlst onlydir\e[0m      \e[90m# ดูแค่โฟลเดอร์\e[0m"
#     echo ""
#     echo -e "\e[1;33mออปชั่น:\e[0m"
#     echo -e "  \e[36m-n, --count 10\e[0m   \e[90mจำนวนไฟล์\e[0m"
#     echo -e "  \e[36m-e, --ext mp4\e[0m   \e[90mกรองนามสกุล\e[0m"
#     echo -e "  \e[36m-S, --size\e[0m       \e[90mเรียงตามขนาด\e[0m"
#     echo -e "  \e[36m-N, --name\e[0m       \e[90mเรียงตามชื่อ\e[0m"
#     echo -e "  \e[36m--old\e[0m            \e[90mเอาเก่าสุดขึ้นก่อน\e[0m"
#     echo -e "  \e[36m-a, --all\e[0m        \e[90mรวมไฟล์ซ่อน\e[0m"
#     return 0
#   fi
#   echo ""
#   echo -e "\e[1;33mดู วิธีการใช้ : lst :\e[0m]"
#   echo ""
#   echo -e "  \e[36mlst -h\e[0m        \e[90m# รายละเอียดการใช้งาน\e[0m"
#   echo ""

#   local n=4
#   local ext=""
#   local sort="modified"
#   local group=""
#   local rev="-r"
#   local all=""
#   local only=""

#   while [[ $# -gt 0 ]]; do
#     case "${1:l}" in
#       -n|--count) n="$2"; shift 2;;
#       -e|--ext) ext="${2#.}"; shift 2;;
#       folder|folders|dir|dirs|directory|directories)
#         group="--group-directories-first"; shift;;
#       onlydir|only-folder|folders-only|dir-only)
#         only="--only-dirs"; group="--group-directories-first"; shift;;
#       --size|-S) sort="size"; shift;;
#       --name|-N) sort="name"; shift;;
#       --old) rev=""; shift;;
#       -a|--all) all="-a"; shift;;
#       [0-9]*) n="$1"; shift;;
#       .*|*.*|mp4|mov|jpg|png|csv|pdf|xlsx|txt)
#         ext="${1#.}"
#         ext="${ext#.}"
#         shift;;
#       *) shift;;
#     esac
#   done

#   local args=(-l -s $sort --icons=always --color=always --git)
#   [[ -n "$rev" ]] && args+=($rev)
#   [[ -n "$group" ]] && args+=($group)
#   [[ -n "$all" ]] && args+=($all)
#   [[ -n "$only" ]] && args+=($only)

#   if [[ -n "$ext" ]]; then
#     eza "${args[@]}" | grep -i "\.${ext}" | head -n $n
#   else
#     eza "${args[@]}" | head -n $n
#   fi
# }



############################################################
############################################################.  Auto Suggestion code

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# eval "$(starship init zsh)"

###################################

### ตั้งค่า git ให้ diff สวย
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true



#######################
################################      