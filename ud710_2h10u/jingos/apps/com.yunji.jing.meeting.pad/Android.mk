LOCAL_PATH:=$(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := com.yunji.jing.meeting.pad.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := com.yunji.jing.meeting.pad
LOCAL_DEX_PREOPT := true
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

