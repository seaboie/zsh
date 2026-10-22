my_test() {

    local arg1="ต้องใส่ ชื่อนะครับ"
    # บังคับตัองใส่ Argument
    local input="$1"; shift

    if [[ -z "$input" ]]; then
        printf "\e[1;33m%s\e[0m" 
        return 1
    fi

    # ตั้งค่า Default ให้ตัวที่ไม่บังคับทั้งหมดก่อน
    local expected="10"
    local go=""
    local noise="-34dB"
    local dur="0.1"

    # วนลูป เช็ค flag ที่เหลือ ใส่ก็ได้ ไม่ใส่ก็ได้
    while [[ $# -gt 0 ]]; do  
        case "$1" in
            --expected) expected="$2"; shift 2;;
            --go)       go="$2";       shift 2;;
            --noise)    noise="$2"     shift 2;;
            --dur)      dur="$2"       shift 2;;
            *) echo "ไม่รู้จัก: $1"; return 1;;
        esac
    done

    printf "\e[1;33m%s\e[0m\n" "input=$input expected=$expected go=$go noise=$noise dur=$dur"
    printf "Hello World"
}