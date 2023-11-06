#!/system/bin/sh

vndk="$(getprop persist.sys.vndk)"
[ -z "$vndk" ] && vndk="$(getprop ro.vndk.version |grep -oE '^[0-9]+')"

if getprop persist.sys.phh.no_vendor_overlay |grep -q true;then
	for part in odm vendor;do
		mount /mnt/phh/empty_dir/ /$part/overlay
	done
fi

if getprop persist.sys.phh.caf.media_profile |grep -q true;then
    setprop media.settings.xml "/vendor/etc/media_profiles_vendor.xml"
fi


minijailSrc=/system/system_ext/apex/com.android.vndk.v28/lib/libminijail.so
minijailSrc64=/system/system_ext/apex/com.android.vndk.v28/lib64/libminijail.so
if [ "$vndk" = 27 ];then
    mount $minijailSrc64 /vendor/lib64/libminijail_vendor.so
    mount $minijailSrc /vendor/lib/libminijail_vendor.so
fi

if [ "$vndk" = 28 ];then
    mount $minijailSrc64 /vendor/lib64/libminijail_vendor.so
    mount $minijailSrc /vendor/lib/libminijail_vendor.so
    mount $minijailSrc64 /system/lib64/vndk-28/libminijail.so
    mount $minijailSrc /system/lib/vndk-28/libminijail.so
    mount $minijailSrc64 /vendor/lib64/libminijail.so
    mount $minijailSrc /vendor/lib/libminijail.so
fi

if [ "$(getprop  persist.sys.phh.duo.disable_hinge)" -eq 1 ]; then
    setprop vendor.display.bezel_size 0
    setprop vendor.display.default_bezel_size 0
    setprop vendor.display.hinge_width_pixels 0
fi

if [ "$(getprop  persist.sys.thain.duo.enable_settings_icons)" -eq 1 ]; then
    setprop vendor.thain.settings_icon 1
fi

if [ "$(getprop  persist.sys.thain.duo.app_hinting)" -eq 1 ]; then
    setprop vendor.thain.app_hinting 1
fi