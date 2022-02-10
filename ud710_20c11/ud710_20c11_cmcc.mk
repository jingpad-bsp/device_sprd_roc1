include device/sprd/roc1/ud710_20c11/ud710_20c11_native.mk

PRODUCT_REVISION := cmcc cta
include $(APPLY_PRODUCT_REVISION)

# Override
PRODUCT_NAME := ud710_20c11_cmcc

DEVICE_PACKAGE_OVERLAYS := $(BOARDDIR)/overlay_cmcc $(BOARDDIR)/overlay $(PLATDIR)/overlay $(PLATCOMM)/overlay

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.mdrec.simpin.cache = 1
