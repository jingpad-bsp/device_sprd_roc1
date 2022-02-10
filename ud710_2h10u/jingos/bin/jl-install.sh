#!/system/bin/sh
PATH=/sbin:/system/sbin:/product/bin:/apex/com.android.runtime/bin:/system/bin:/system/xbin

function install() {
    copy=$(getprop persist.debug.jl.install 0)
    if [ "$copy" = "0" ]; then
        apks=$(find /system/jlpreinstall/app/*)
        for apk in $apks; do
            pm install -r $apk
        done
    fi
}

install
setprop debug.jl.install 1