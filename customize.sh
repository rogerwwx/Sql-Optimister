
chooseport() {
getevent -qlc 1 >/dev/null 2>&1
    while true; do
        # 捕获按键事件并过滤出按下动作
        local key_event=$(getevent -qlc 1 2>/dev/null | 
            awk '/KEY_VOLUMEUP/ {print "KEY_VOLUMEUP"; exit} 
                 /KEY_VOLUMEDOWN/ {print "KEY_VOLUMEDOWN"; exit}')
        [[ -n "$key_event" ]] && break
    done
    [[ "$key_event" == "KEY_VOLUMEUP" ]] && return 0 || return 1
}
key_source(){
if test -e "$1" ;then
	source "$1"
	rm -rf "$1"
fi
}
show_prompt() {
    ui_print "║  $1 ║"
    ui_print "║                                      ║"
    ui_print "║  音量上键: 要 ✅                  ║"
    ui_print "║  音量下键: 不要❌                  ║"
    ui_print "╚══════════════════════════════════════╝"
    ui_print " "
    chooseport
    return $?
}


neicunyazhi(){
if show_prompt "❄️是否开启数据库额外优化，会占用极小部分手机空间，但是会更省电以及软件运行速度加快，❄️"; then
    ui_print "✅ 已开启额外优化"
sed -i 's/^SQLite额外优化=.*/SQLite额外优化=1/' $MODPATH/内存压制.md
else
    ui_print "⏹️ 已关闭额外优化" 
    sed -i 's/^SQLite额外优化=.*/SQLite额外优化=0/' $MODPATH/内存压制.md
fi
}
neicunyazhi
# --- 设置权限 ---
ui_print "- 正在设置模块文件权限"
# 设置模块目录和文件的基础权限
set_perm_recursive $MODPATH 0 0 0777 0777

# 为二进制文件和脚本设置可执行权限和 SELinux 上下文
# 这确保了它们可以在开启 SELinux 强制模式的系统上执行。
ui_print "- 正在设置可执行权限和 SELinux 上下文"
ui_print "- 正在设置可执行权限和 SELinux 上下文"

# 设置 MODPATH 下所有文件的权限
if [ "$KSU" = "true" ]; then
    # KernelSU 环境：不指定 SELinux context，使用系统默认
    find "$MODPATH" -type f -exec chmod 0777 {} \;
    find "$MODPATH" -type f -exec chown 0:2000 {} \;
    ui_print "ksu"
else
    # Magisk 环境：使用 magisk_file SELinux context
    find "$MODPATH" -type f -exec chmod 0777 {} \;
    find "$MODPATH" -type f -exec chown 0:2000 {} \;
    find "$MODPATH" -type f -exec chcon u:object_r:magisk_file:s0 {} \;
    ui_print "magisk"
fi
am start -d 'coolmarket://u/37304191' >/dev/null 2>&1