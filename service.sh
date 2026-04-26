#!/system/bin/sh
#
MODDIR=${0%/*}



until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done





setsid $MODDIR/bin/neicunyazhi2 >/dev/null 2>&1 &