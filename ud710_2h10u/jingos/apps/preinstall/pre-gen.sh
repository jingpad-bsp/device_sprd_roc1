#!/bin/bash
rm device.mk
for apk in *.apk;do
echo $apk;
pkg=`aapt d badging $apk | grep -E -o "package: name\S*"`
pkg=${pkg:15};pkg=${pkg:0:${#pkg}-1}
echo "PRODUCT_PACKAGES += ${pkg}" >> device.mk
rm -rf $pkg
mkdir $pkg
ln -rs $apk $pkg/$pkg.apk
amk=$pkg/Android.mk
echo 'LOCAL_PATH:=$(call my-dir)' >> $amk
echo 'include $(CLEAR_VARS)' >> $amk
echo "LOCAL_SRC_FILES := ${pkg}.apk" >> $amk
echo 'LOCAL_MODULE_CLASS := APPS' >> $amk
echo 'LOCAL_MODULE_TAGS := optional' >> $amk
echo "LOCAL_MODULE := ${pkg}" >> $amk
echo 'LOCAL_DEX_PREOPT := false' >> $amk
echo "LOCAL_CERTIFICATE := PRESIGNED" >> $amk
echo 'LOCAL_MODULE_PATH := $(TARGET_OUT)/vital-app/' >> $amk
echo 'include $(BUILD_PREBUILT)' >> $amk
echo '' >> $amk


done