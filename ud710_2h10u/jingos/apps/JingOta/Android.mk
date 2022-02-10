LOCAL_PATH := $(call my-dir)

###################### 编译 JingOta #####################
include $(CLEAR_VARS)

#模块名
LOCAL_MODULE := JingOta

#应用
LOCAL_MODULE_CLASS := APPS

#签名
LOCAL_CERTIFICATE := platform
LOCAL_SRC_FILES := $(LOCAL_MODULE).apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

#编译后的输出目录
# LOCAL_MODULE_PATH := $(TARGET_OUT)/priv-app


LOCAL_PREBUILT_JNI_LIBS := \
@lib/arm64-v8a/libbdca.so \
@lib/arm64-v8a/libotaso.so \
@lib/arm64-v8a/libsharememory.so


LOCAL_DEX_PREOPT := true
include $(BUILD_PREBUILT)