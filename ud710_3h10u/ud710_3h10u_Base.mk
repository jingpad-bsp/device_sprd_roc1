#
# Copyright 2015 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PLATDIR := device/sprd/roc1
PLATCOMM := $(PLATDIR)/common
TARGET_BOARD := ud710_3h10u
BOARDDIR := $(PLATDIR)/$(TARGET_BOARD)
ROOTDIR := $(BOARDDIR)/rootdir
TARGET_BOARD_PLATFORM := ud710

TARGET_NO_BOOTLOADER := false
AUDIO_SMARTAMP_CONFIG =unsupport
ifneq ($(AUDIO_SMARTAMP_CONFIG), unsupport)
#USE_AUDIO_SMARTAMP := fbsmartamp
endif

ifeq ($(AUDIO_HIFI_CONFIG), support)
USE_AUDIO_HIFI := audiohifi
endif

USE_AUDIO_WHALE_HAL :=true
USE_AWINIC_EFFECT_HAL :=true
USE_XML_AUDIO_POLICY_CONF := 1
SPRD_AUDIO_HIDL_CLIENT_SUPPORT := true
SPRD_AUDIO_HIDL_CLIENT_VERSION := v5
USE_CONFIGURABLE_AUDIO_POLICY := 1
USE_CUSTOM_CONFIGUREABLE_AUDIO_POLICY := true
BUILD_AUDIO_POLICY_CONFIGURATION := phone_configurable
AUDIO_PFW_PATH := $(ROOTDIR)/system/etc/parameter-framework
AUDIO_PFW_EDD_FILES := \
        $(AUDIO_PFW_PATH)/Settings/device_for_input_source.pfw \
        $(AUDIO_PFW_PATH)/Settings/volumes.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_media.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_accessibility.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_dtmf.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_enforced_audible.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_phone.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_sonification.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_sonification_respectful.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_transmitted_through_speaker.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_rerouting.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_fm.pfw \
        $(AUDIO_PFW_PATH)/Settings/device_for_product_strategy_patch.pfw
# modem
USE_SPRD_ORCA_MODEM := true
BOARD_EXTERNAL_MODEM := true

# graphics
USE_SPRD_HWCOMPOSER  := true

# support gnss hidl
SUPPORT_GNSS_HARDWARE := true
SPRD_MODULES_GNSS3 := true

# support location
SUPPORT_LOCATION := enabled

# AI core version
TARGET_AICORE_VERSION := 1.0

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, $(PLATCOMM)/DeviceCommon.mk)
$(call inherit-product, $(PLATCOMM)/proprietories.mk)
$(call inherit-product-if-exists, vendor/sprd/modules/libcamera/libcam_device.mk)
$(call inherit-product-if-exists, vendor/sprd/modules/faceunlock/faceunlock_device.mk)
$(call inherit-product-if-exists, vendor/sprd/modules/vdsp/Cadence/xrp/vdsp_service.mk)
#vdsp nn hal
$(call inherit-product-if-exists, vendor/sprd/modules/vdsp/Cadence/nnhal/device-vdsp-nnhal.mk)
# add for sprd super resultion and picture quality feature
PRODUCT_PACKAGES += LowResolutionPowerSaving

BOARD_HAVE_SPRD_WCN_COMBO := marlin3
BOARD_SPRD_WCN_SOCKET := pcie
$(call inherit-product-if-exists, vendor/sprd/modules/wcn/connconfig/device-sprd-wcn.mk)
$(call inherit-product-if-exists, vendor/sprd/modules/wlan/wlanconfig/device-sprd-wlan.mk)

# set compatible memory device switch
BOARD_MEMORY_COMPATIBLE := --board_compatible
# select UFS or Emmc
BOARD_MEMORY_TYPE := ufs

#enable F2FS for userdata.img
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

#fstab
ifeq (f2fs,$(strip $(BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE)))
  NORMAL_FSTAB_SUFFIX1 := .f2fs
endif

$(warning BOARD_SECBOOT_CONFIG=$(BOARD_SECBOOT_CONFIG))
ifeq (false,$(strip $(BOARD_SECBOOT_CONFIG)))
  NORMAL_FSTAB_SUFFIX2 :=.nosec
endif
NORMAL_FSTAB_SUFFIX := $(NORMAL_FSTAB_SUFFIX1)$(NORMAL_FSTAB_SUFFIX2)
$(warning NORMAL_FSTAB=$(LOCAL_PATH)/rootdir/root/fstab.$(TARGET_BOARD)$(NORMAL_FSTAB_SUFFIX))
# For Dynamic partitions feature, fstab install to ramdisk
PRODUCT_COPY_FILES += $(BOARDDIR)/rootdir/root/fstab.$(TARGET_BOARD)$(NORMAL_FSTAB_SUFFIX):vendor/etc/fstab.$(TARGET_BOARD)
$(warning RAMDISK_FSTAB=$(BOARDDIR)/rootdir/root/fstab.ramdisk$(NORMAL_FSTAB_SUFFIX2))
PRODUCT_COPY_FILES += $(BOARDDIR)/rootdir/root/fstab.ramdisk$(NORMAL_FSTAB_SUFFIX2):$(TARGET_COPY_OUT_RAMDISK)/fstab.$(TARGET_BOARD)

#include vendor/sprd/modules/devdrv/input/misc/tcs3430/tcs3430.mk
#PRODUCT_PACKAGES += \
        tcs3430.ko

PRODUCT_COPY_FILES += \
    $(BOARDDIR)/rootdir/root/init.$(TARGET_BOARD).rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(TARGET_BOARD).rc \
    $(ROOTDIR)/prodnv/PCBA.conf:$(TARGET_COPY_OUT_VENDOR)/etc/PCBA.conf \
    $(ROOTDIR)/prodnv/BBAT.conf:$(TARGET_COPY_OUT_VENDOR)/etc/BBAT.conf \
    $(ROOTDIR)/system/etc/audio_params/audio_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_config.xml \
    $(ROOTDIR)/system/etc/audio_params/audio_pcm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_pcm.xml \
    $(PLATCOMM)/rootdir/root/ueventd.$(BOARD_MEMORY_TYPE).common.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    $(PLATCOMM)/rootdir/root/init.common.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(TARGET_BOARD).usb.rc \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    $(BOARDDIR)/log_conf/slog_modem_$(TARGET_BUILD_VARIANT).conf:vendor/etc/slog_modem.conf \
    $(BOARDDIR)/log_conf/slog_modem_cali.conf:vendor/etc/slog_modem_cali.conf \
    $(BOARDDIR)/log_conf/slog_modem_factory.conf:vendor/etc/slog_modem_factory.conf \
    $(BOARDDIR)/log_conf/slog_modem_autotest.conf:vendor/etc/slog_modem_autotest.conf \
    $(BOARDDIR)/log_conf/mlogservice_$(TARGET_BUILD_VARIANT).conf:vendor/etc/mlogservice.conf \
    $(BOARDDIR)/modem_conf/modem_cp_info.xml:vendor/etc/modem_cp_info.xml \
    $(BOARDDIR)/modem_conf/modem_sp_info.xml:vendor/etc/modem_sp_info.xml \
    $(BOARDDIR)/modem_conf/modem_dp_info.xml:vendor/etc/modem_dp_info.xml \
    $(BOARDDIR)/features/otpdata/otpgoldendata.txt:system/etc/otpdata/otpgoldendata.txt \
    $(BOARDDIR)/features/otpdata/input_parameters_values.txt:system/etc/otpdata/input_parameters_values.txt \
    $(BOARDDIR)/features/otpdata/obj_disc.txt:system/etc/otpdata/obj_disc.txt \
    $(BOARDDIR)/features/otpdata/sell_aft_cali.txt:system/etc/otpdata/sell_aft_cali.txt \
    $(BOARDDIR)/features/otpdata/sale_after_input_parameters_values.txt:system/etc/otpdata/sale_after_input_parameters_values.txt \
    $(BOARDDIR)/features/otpdata/spw_input_parameters_values.txt:system/etc/otpdata/spw_input_parameters_values.txt \
    $(BOARDDIR)/features/otpdata/oz1_input_parameters_values.txt:system/etc/otpdata/oz1_input_parameters_values.txt \
    $(BOARDDIR)/features/otpdata/oz2_input_parameters_values.txt:system/etc/otpdata/oz2_input_parameters_values.txt

ifeq ($(USE_AUDIO_HIFI), audiohifi)
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_params/audio_route_hifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_route.xml
else
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_params/audio_route.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_route.xml
endif

ifeq ($(USE_AUDIO_SMARTAMP), fbsmartamp)
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/audioparam_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audioparam_config.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/audio_pga.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_pga.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/audio_process.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_process.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/audio_structure.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_structure.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/codec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/codec.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/cvs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/cvs.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/dsp_vbc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/dsp_vbc.xml \
    $(ROOTDIR)/system/etc/audio_params/SmartAmp/dsp_smartamp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/dsp_smartamp.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/smartamp_primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml
else
ifeq ($(USE_AUDIO_HIFI), audiohifi)
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/audioparam_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audioparam_config.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/audio_pga.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_pga.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/audio_process.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_process.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/audio_structure.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_structure.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/codec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/codec.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/cvs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/cvs.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd_hifi/dsp_vbc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/dsp_vbc.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml
else
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_params/sprd/audioparam_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audioparam_config.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd/audio_pga.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_pga.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd/audio_process.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_process.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd/audio_structure.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/audio_structure.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd/codec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/codec.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd/cvs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/cvs.xml \
    $(ROOTDIR)/system/etc/audio_params/sprd/dsp_vbc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_params/sprd/dsp_vbc.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml
endif
endif

#copy audio policy config
ifeq ($(USE_XML_AUDIO_POLICY_CONF), 1)
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_policy_config/audio_policy_configuration_bluetooth_legacy_hal.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_bluetooth_legacy_hal.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/audio_policy_configuration_configurable_a2dp_offload_disabled.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_a2dp_offload_disabled.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/bluetooth_audio_policy_configuration_disable_offload.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_disable_offload.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/audio_policy_configuration_smart_pa.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_smart_pa.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/primary_audio_policy_configuration_smart_pa.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration_smart_pa.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(ROOTDIR)/system/etc/audio_policy_config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml
else
PRODUCT_COPY_FILES += \
    $(ROOTDIR)/system/etc/audio_params/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
endif
# Aw87519 config file
PRODUCT_COPY_FILES += \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_fm_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_fm_0.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_off_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_off_0.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_rcv_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_rcv_0.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_voice_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_voice_0.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_music_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_music_0.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_fm_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_fm_1.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_off_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_off_1.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_rcv_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_rcv_1.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_voice_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_voice_1.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_pid_59_music_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_pid_59_music_1.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_vmax_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_vmax_0.bin \
	device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/aw87xxx_vmax_1.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/aw87xxx_vmax_1.bin
#Aw stk3
PRODUCT_COPY_FILES += \
 device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/awinic_params.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/awinic_params.bin \
 device/sprd/roc1/ud710_3h10u/rootdir/system/etc/audio_params/awinic/awinic.audio.effect.so:$(TARGET_COPY_OUT_VENDOR)/lib/hw/awinic.audio.effect.so

#elan tp mmi

PRODUCT_COPY_FILES += \
 device/sprd/roc1/ud710_3h10u/rootdir/system/etc/tp/elanchip_3542_raw.csv:$(TARGET_COPY_OUT_VENDOR)/firmware/elanchip_3542_raw.csv

# config sensor features supported by this board
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

#mag sensor cali
PRODUCT_COPY_FILES += \
    vendor/sprd/modules/sensors/libsensorhub/ConfigSensor/calibration/mag_cali/mmc5603_and_stk3a5x_img_ud710_2h10.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/EXEC_CALIBRATE_MAG_IMAGE


#camera sensor config
PRODUCT_COPY_FILES += \
    $(BOARDDIR)/camera/sensor_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sensor_config.xml

# config sepolicy
#duplicate definition
#BOARD_SEPOLICY_DIRS += device/sprd/roc1/common/sepolicy \
#    build/target/board/generic/sepolicy

SPRD_GNSS_ARCH := arm64
# GNSS
ifeq ($(strip $(SUPPORT_GNSS_HARDWARE)), true)
SPRD_GNSS_SHARKLE_PIKL2 := true
$(call inherit-product, vendor/sprd/modules/wcn/gnss/device-sprd-gps.mk)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.gnsschip=marlin3pcie
endif

#WCN config
#add for wcn kernel defconfig
#BOARD_WCN_CONFIG := built-in
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.modem.wcn.enable=1 \
    ro.vendor.modem.wcn.diag=/dev/slog_wcn0 \
    ro.vendor.modem.wcn.id=1 \
    ro.vendor.modem.wcn.count=1 \
    ro.vendor.modem.gnss.diag=/dev/slog_gnss \
    ro.vendor.wcn.gpschip=marlin3

#Display/Graphic config
PRODUCT_PROPERTY_OVERRIDES += \
      ro.sf.lcd_density=320 \
      ro.sf.lcd_width=54 \
      ro.sf.lcd_height=96 \
      ro.opengles.version=196610

#    Email2
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SprdContacts \
    SprdContactsProvider \
    Exchange2 \
    ExactCalculator \
    SprdDeskClock \
    DreamSoundRecorder \
    Settings \
    SettingsProvider \
    SprdMediaProvider \
    SprdDialer \
    SprdCalendarProvider \
    DreamCamera2 \
    QuickCamera \
    NewMusic \
    MusicFX \
    NewGallery2 \
    SystemUI \
    Launcher3 \
    webview
#    SprdCalendar

# Dual-sim config
PRODUCT_PACKAGES += \
        Stk1 \
        MsmsStk

# Screen Capture
PRODUCT_PACKAGES += \
        ScreenCapture

# enable dual camera calibration
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera.dualcamera_cali_enable=1
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.camera.dualcamera_cali_time=3

# config video engine for VOLTE video call
VOLTE_SERVICE_ENABLE := true
ifeq ($(strip $(VOLTE_SERVICE_ENABLE)), true)
PRODUCT_PROPERTY_OVERRIDES += persist.sys.vilte.socket=ap
endif

# sprd hw module
PRODUCT_PACKAGES += \
	lights.$(TARGET_BOARD_PLATFORM) \
	sensors.$(TARGET_BOARD_PLATFORM) \
	camera.$(TARGET_BOARD_PLATFORM) \
	tinymix \
	audio.primary.$(TARGET_BOARD_PLATFORM) \
        audio.bluetooth.$(TARGET_BOARD_PLATFORM) \
        libaudionpi \
        libaudioparamteser \
        libbundlewrapper2 \
        parameter-framework.policy \
#	audio_hardware_test \
#	power.$(TARGET_BOARD_PLATFORM) \
	memtrack.$(TARGET_BOARD_PLATFORM)

# dpu enhance module
PRODUCT_PACKAGES += \
	enhance.$(TARGET_BOARD_PLATFORM) \
	enhance_test

# dpu PQTune module
PRODUCT_PACKAGES += \
	PQTune.$(TARGET_BOARD_PLATFORM)

PRODUCT_PACKAGES += memtrack.$(TARGET_BOARD_PLATFORM)


#SANSA|SPRD|NONE
PRODUCT_HOST_PACKAGES += imgheaderinsert \
                         packimage.sh

PRODUCT_PACKAGES += iwnpi \
                    libiwnpi \
		    libwifieut_m3 \
                    FMRadio \
                    #libGLES_android \
                    gralloc.$(TARGET_BOARD_PLATFORM)

#secure chip et200
PRODUCT_PACKAGES += crc_test

##faceid feature
#FACEID_FEATURE_SUPPORT := true
#FACEID_TEE_FULL_SUPPORT := true

#app stats collect
PRODUCT_PROPERTY_OVERRIDES += persist.sys.pwctl.appstats=1
PRODUCT_PACKAGES += \
        AppStatsService

# add for validationtools disable FM
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.validationtools.fmdisable=1

#portrait scene
TARGET_BOARD_PORTRAIT_SCENE_SUPPORT := true
