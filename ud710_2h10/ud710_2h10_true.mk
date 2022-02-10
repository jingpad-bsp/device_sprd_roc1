include device/sprd/roc1/ud710_2h10/ud710_2h10_native.mk

PRODUCT_REVISION := oversea true multi-lang
include $(APPLY_PRODUCT_REVISION)

# Override
PRODUCT_NAME := ud710_2h10_true

#enable VoWiFi
VOWIFI_SERVICE_ENABLE := true
