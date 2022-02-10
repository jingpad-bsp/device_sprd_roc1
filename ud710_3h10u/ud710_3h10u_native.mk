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
KERNEL_PATH := kernel4.14
export KERNEL_PATH
$(call inherit-product, device/sprd/roc1/ud710_3h10u/ud710_3h10u_Base.mk)
PLATDIR := device/sprd/roc1
TARGET_BOARD := ud710_3h10u
BOARDDIR := $(PLATDIR)/$(TARGET_BOARD)
PLATCOMM := $(PLATDIR)/common
ROOTDIR := $(BOARDDIR)/rootdir
TARGET_BOARD_PLATFORM := ud710
TARGET_GPU_PLATFORM := rogue
GRAPHIC_RENDER_TYPE := GPU

TARGET_BOOTLOADER_BOARD_NAME := ud710_3h10u
CHIPRAM_DEFCONFIG := ud710_3h10u
UBOOT_DEFCONFIG := ud710_3h10u
UBOOT_TARGET_DTB := ud710_3h10u

PRODUCT_NAME := ud710_3h10u_native
PRODUCT_DEVICE := ud710_3h10u
PRODUCT_BRAND := JingPad 
PRODUCT_MODEL := JingPad C1
PRODUCT_WIFI_DEVICE := sprd
PRODUCT_MANUFACTURER := JingLing

DEVICE_PACKAGE_OVERLAYS := $(BOARDDIR)/overlay $(PLATDIR)/overlay $(PLATCOMM)/overlay

#Runtime Overlay Packages
PRODUCT_ENFORCE_RRO_TARGETS := \
    framework-res

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_KERNEL_ARCH = arm64
TARGET_USES_64_BIT_BINDER := true

#add for microarray fingerprint
#BOARD_FINGERPRINT_CONFIG := microarray
BOARD_FINGERPRINT_CONFIG := goodix 
BOARD_FINGERPRINT_CONFIG1 := silead

#secure boot
BOARD_SECBOOT_CONFIG := true
BOARD_TEE_CONFIG := trusty

#do not verify modem
BOARD_NOT_VERIFY_MODEM := true

#faceid feature
FACEID_FEATURE_SUPPORT := true
FACEID_TEE_FULL_SUPPORT := true

$(call inherit-product, $(PLATCOMM)/security_feature.mk)

#enable 3dnr & bokeh
PRODUCT_PROPERTY_OVERRIDES += \
        persist.vendor.cam.3dnr.version=1 \
        persist.vendor.cam.ba.blur.version=6 \
        persist.vendor.cam.fr.blur.version=1 \
        persist.vendor.cam.api.version=0
#bokeh picture size
PRODUCT_PROPERTY_OVERRIDES += \
   persist.vendor.cam.res.bokeh=RES_12M

#MMI main menu camera calibration & verification entry: 0-not display, 1-display
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.multicam.cali.veri=0
#MMI opticszoom calibration mode: 1-SW+W, 2-W+T, 3-SW+W+T
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.opticszoom.cali.mode=3

#set bokeh aux vcm
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.focus.distance=300

#enable beauty
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.facebeauty.corp=2

#enable cnr
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.cnr.mode=1

#enable ai
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.ai.scence.enable=true

#enable wt
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.wt.enable=0

#enable hdr_zsl
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.hdr.zsl=1

#Display PQ
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.pq.cabc.enabled=0

#enable nightshot pro
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.night.pro.enable=0

PRODUCT_COPY_FILES += \
    $(BOARDDIR)/ud710_3h10u.xml:$(PRODUCT_OUT)/ud710_3h10u.xml

PRODUCT_AAPT_CONFIG := normal large xlarge mdpi 420dpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
PRODUCT_AAPT_PREBUILT_DPI := 480dpi xxhdpi

#Preset TouchPal InputMethod
PRODUCT_REVISION := multi-lang

# add for lattice
LATTICE_SUPPORT := true


#ValidationTools prop
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.mmi.camera.sensor.cct=ams_tcs3430

#enable TUI
BOARD_TUI_CONFIG := false

# add for ifaa
BOARD_IFAA_TRUSTY := true

#enable soter
BOARD_SOTER_TRUSTY := treble

#For Modem build
PRODUCT_MODEM_COPY_LIST :=

# FOR BSP
TARGET_BSP_OUT := bsp/out/$(TARGET_BOARD)/dist
TARGET_PREBUILT_KERNEL := $(TARGET_BSP_OUT)/kernel/Image
BSP_DTB_NAME := ud710-3h10u
TARGET_PREBUILT_DTB := $(TARGET_BSP_OUT)/kernel/$(BSP_DTB_NAME).dtb

PRODUCT_COPY_FILES += $(TARGET_PREBUILT_KERNEL):kernel

BOARD_PREBUILT_DTBOIMAGE := $(TARGET_BSP_OUT)/kernel/dtbo.img

# For bsp ko partitions build
PRODUCT_VENDOR_KO_MOUNT_POINT := /mnt/vendor
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.ko.mount.point=$(PRODUCT_VENDOR_KO_MOUNT_POINT)

BSP_KERNEL_MODULES_OUT := $(TARGET_BSP_OUT)/modules

PRODUCT_SOCKO_KO_LIST := \
    $(BSP_KERNEL_MODULES_OUT)/flash_ic_sc2703.ko \
    $(BSP_KERNEL_MODULES_OUT)/pvrsrvkm.ko \
    $(BSP_KERNEL_MODULES_OUT)/sprd_flash_drv.ko \
    $(BSP_KERNEL_MODULES_OUT)/sprdwl_ng.ko \
    $(BSP_KERNEL_MODULES_OUT)/sprdbt_tty.ko \
    $(BSP_KERNEL_MODULES_OUT)/sprd_fm.ko \
    $(BSP_KERNEL_MODULES_OUT)/sprd_sensor.ko\
    $(BSP_KERNEL_MODULES_OUT)/sprd_camera.ko\
    $(BSP_KERNEL_MODULES_OUT)/sprd_fd.ko\
    $(BSP_KERNEL_MODULES_OUT)/sprd_cpp.ko\
    $(BSP_KERNEL_MODULES_OUT)/mmdvfs.ko\
    $(BSP_KERNEL_MODULES_OUT)/tcs3430.ko\
    $(BSP_KERNEL_MODULES_OUT)/stmvl53l0.ko\
    $(BSP_KERNEL_MODULES_OUT)/sprd_vdsp.ko\
    $(BSP_KERNEL_MODULES_OUT)/vdsp_sipc.ko\
    $(BSP_KERNEL_MODULES_OUT)/vdsp_spipe.ko\
    $(BSP_KERNEL_MODULES_OUT)/gt738x_ts.ko\
    $(BSP_KERNEL_MODULES_OUT)/elan_ts_i2c.ko\
    $(BSP_KERNEL_MODULES_OUT)/npu_img_mem.ko \
    $(BSP_KERNEL_MODULES_OUT)/npu_img_vha.ko

ifeq ($(strip $(BOARD_FINGERPRINT_CONFIG)), microarray)
PRODUCT_SOCKO_KO_LIST += $(BSP_KERNEL_MODULES_OUT)/microarray_fp.ko
endif

ifeq ($(strip $(BOARD_FINGERPRINT_CONFIG)), goodix)
PRODUCT_SOCKO_KO_LIST += $(BSP_KERNEL_MODULES_OUT)/goodix_fp.ko
endif

ifeq ($(strip $(BOARD_FINGERPRINT_CONFIG1)), silead)
PRODUCT_SOCKO_KO_LIST += $(BSP_KERNEL_MODULES_OUT)/silead_fp.ko
endif
HAVE_EXTRA_SOCKO := $(shell test -d bsp/modules/audio/akm4377 && echo yes)
ifeq ($(HAVE_EXTRA_SOCKO), yes)
PRODUCT_SOCKO_KO_LIST += $(BSP_KERNEL_MODULES_OUT)/akm4377.ko
endif

# Gets ko list by ko dirs and ko names
ifeq ($(strip $(PRODUCT_SOCKO_KO_LIST)),)
PRODUCT_SOCKO_KO_DIRS := \
    $(BSP_KERNEL_MODULES_OUT)

PRODUCT_SOCKO_KO_NAMES :=
endif

PRODUCT_ODMKO_KO_LIST :=

# Gets ko list by ko dirs and ko names
ifeq ($(strip $(PRODUCT_ODMKO_KO_LIST)),)
PRODUCT_ODMKO_KO_DIRS := \
    $(BSP_KERNEL_MODULES_OUT)

PRODUCT_ODMKO_KO_NAMES :=
endif

#ip feature list
#enable back portrait mode
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.ba.portrait.enable=0
#enable front portrait mode
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.cam.fr.portrait.enable=0

#build.prop
JINGPAD_BOARD_NAME := S813_V1


#config the board to 5G
PRODUCT_PROPERTY_OVERRIDES := \
    ro.telephony.default_network=26 \
$(PRODUCT_PROPERTY_OVERRIDES)

#Device type is tablet
PRODUCT_CHARACTERISTICS := tablet

#RuntimeTest feature
 PRODUCT_PACKAGES += \
 		RuntimeTest

#internal software version
SOFTWARE_INTERNAL_VERSION :=1.0.0002.013


ifeq ($(strip $(LATTICE_SUPPORT)),true)
PRODUCT_PROPERTY_OVERRIDES += \
ro.vendor.xunrui.use.lattice=true
endif

include device/sprd/roc1/ud710_2h10u/jingos/device.mk
