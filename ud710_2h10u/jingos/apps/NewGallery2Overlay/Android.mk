LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

#LOCAL_RRO_THEME := IconPackFilledAndroid

LOCAL_PRODUCT_MODULE := true

LOCAL_SRC_FILES := $(call all-subdir-java-files)

LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res

LOCAL_PACKAGE_NAME := NewGallery2Overlay
LOCAL_SDK_VERSION := current
LOCAL_CERTIFICATE := platform
LOCAL_AAPT_FLAGS := -c all
include $(BUILD_PACKAGE)