LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)


$(shell mkdir -p $(TARGET_OUT)/jlpreinstall/app)

LOCAL_MODULE := jl-install.sh
LOCAL_SRC_FILES := jl-install.sh
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)
