# Copyright (C) 2015 The Android Open Source Project
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
# Modem Functions

LOCAL_PATH := device/sprd/roc1/common
include $(LOCAL_PATH)/PartitionPath.mk

PRODUCT_PACKAGES += \
    calibration_init \
    engpc \
    modem_control \
    refnotify \
    slogmodem \
    slogmodem_vendor \
    iqfeed \
    cplogctl \
    cp_diskserver \
    mlogservice \
    libreadfixednv \
    libcomcontrol

# Modem Prop
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.modem.log_dest=0 \
    persist.vendor.wcn.log_dest=0 \
    persist.vendor.sys.modemreset=1 \
    persist.vendor.sys.modem.save_dump=0
else
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.modem.log_dest=2 \
    persist.vendor.wcn.log_dest=2 \
    persist.vendor.sys.modemreset=0 \
    persist.vendor.sys.modem.save_dump=1
endif # TARGET_BUILD_VARIANT == user

ifeq ($(strip $(USE_SPRD_ORCA_MODEM)), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.product.partitionpath=$(PartitionPath)/ \
    ro.vendor.modem.ep.device.path=/sys/bus/pci/ \
    ro.vendor.modem.ep.vendor.id=0x16c3 \
    ro.vendor.modem.ep.device.id=0xabcd \
    ro.vendor.modem.ep.class.id=0x0d8000 \
    ro.vendor.modem.dev=/dev/modem/ \
    ro.vendor.modem.tty=/dev/stty_nr \
    ro.vendor.modem.command=/dev/spipe_nr0 \
    ro.vendor.modem.eth=sipa_eth \
    ro.vendor.modem.snd=1 \
    ro.vendor.modem.diag=/dev/sdiag_nr \
    ro.vendor.modem.log=/dev/slog_nr \
    ro.vendor.modem.miniap.log=/dev/spipe_nr7 \
    ro.vendor.modem.dp.log=/dev/spipe_nr1 \
    ro.vendor.modem.loop=/dev/spipe_nr0 \
    ro.vendor.modem.nv=/dev/snv_nr \
    ro.vendor.modem.assert=/dev/spipe_nr2 \
    ro.vendor.modem.alive=/dev/spipe_nr2 \
    ro.modem.l.vbc=/dev/spipe_lte6 \
    ro.modem.l.id=0 \
    ro.vendor.modem.fixnv_size=0x700000 \
    ro.vendor.modem.runnv_size=0x900000 \
    ro.vendor.modem.nvpacket_size=0x40000 \
    persist.vendor.modem.nvp=nr_ \
    persist.vendor.modem.nr.enable=1 \
    ro.vendor.sp.log=/dev/slog_pm \
    persist.vendor.sys.isfirstboot=1 \
    ro.vendor.ag.log=/dev/audio_dsp_log \
    ro.vendor.ag.pcm=/dev/audio_dsp_pcm \
    ro.vendor.ag.mem=/dev/audio_dsp_mem
ifeq ($(strip $(BOARD_REMOVE_SPRD_MODEM)), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.radio.modemtype=none
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.radio.modemtype=nr
endif
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.product.partitionpath=$(PartitionPath)/ \
    ro.vendor.modem.dev=/proc/cptl/ \
    ro.vendor.modem.tty=/dev/stty_lte \
    ro.vendor.modem.eth=seth_lte \
    ro.vendor.modem.snd=1 \
    ro.vendor.radio.modemtype=l \
    ro.vendor.modem.diag=/dev/sdiag_lte \
    ro.vendor.modem.log=/dev/slog_lte \
    ro.vendor.modem.loop=/dev/spipe_lte0 \
    ro.vendor.modem.nv=/dev/spipe_lte1 \
    ro.vendor.modem.assert=/dev/spipe_lte2 \
    ro.modem.l.vbc=/dev/spipe_lte6 \
    ro.modem.l.id=0 \
    ro.vendor.modem.fixnv_size=0x100000 \
    ro.vendor.modem.runnv_size=0x120000 \
    persist.vendor.modem.nvp=l_ \
    persist.vendor.modem.l.enable=1 \
    ro.vendor.sp.log=/dev/slog_pm \
    persist.vendor.sys.isfirstboot=1 \
    ro.vendor.ag.log=/dev/audio_dsp_log \
    ro.vendor.ag.pcm=/dev/audio_dsp_pcm \
    ro.vendor.ag.mem=/dev/audio_dsp_mem
endif

SPRD_CP_LOG_AGDSP := true
