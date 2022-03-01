PRODUCT_PACKAGE_OVERLAYS += device/sprd/roc1/ud710_2h10u/jingos/overlay
CURDIR := device/sprd/roc1/ud710_2h10u/jingos
include ${CURDIR}/bootanimation/bootanimation.mk

PRODUCT_PROPERTY_OVERRIDES += \
ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural_wide_back \
persist.sys.language=en \
persist.sys.country=US \
persist.sys.timezone=US/Eastern \
persist.sys.locale=en-US \
ro.product.locale.language=en \
ro.product.locale.region=US


PRODUCT_PACKAGES += \
	JingOta \
	jl-install.sh \
	JingosLog \
	JingCenter \
	com.yozo.office \
	com.asa.jingnote \
	JingSettings


#jingos white package list
PRODUCT_COPY_FILES += \
    device/sprd/roc1/ud710_2h10u/jingos/jingos_whiteList:$(TARGET_COPY_OUT_VENDOR)/etc/jingos_whiteList \
    frameworks/base/core/java/com/jingos/mdm/mdm.sh:system/bin/mdm.sh

include ${CURDIR}/apps/preinstall/device.mk
include ${CURDIR}/apps/postinstall/device.mk
include ${CURDIR}/ota.mk
include ${CURDIR}/translation/device.mk
