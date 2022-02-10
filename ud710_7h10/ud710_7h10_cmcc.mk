include device/sprd/roc1/ud710_7h10/ud710_7h10_native.mk

PRODUCT_REVISION := cmcc
include $(APPLY_PRODUCT_REVISION)

# Override
PRODUCT_NAME := ud710_7h10_cmcc

DEVICE_PACKAGE_OVERLAYS := $(BOARDDIR)/overlay_cmcc $(BOARDDIR)/overlay $(PLATDIR)/overlay $(PLATCOMM)/overlay

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.mdrec.simpin.cache = 1

