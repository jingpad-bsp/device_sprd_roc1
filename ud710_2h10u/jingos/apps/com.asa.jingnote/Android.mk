LOCAL_PATH:=$(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := com.asa.jingnote.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := com.asa.jingnote
LOCAL_DEX_PREOPT := true
LOCAL_PRIVILEGED_MODULE := true
LOCAL_REQUIRED_MODULES := com.asa.jingnote.xml
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)
LOCAL_MODULE := com.asa.jingnote.xml
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/permissions
include $(BUILD_PREBUILT)

