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


PRODUCT_MAKEFILES += \
        ud710_2h10_native:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_native.mk \
        ud710_10h10_native:$(LOCAL_DIR)/ud710_10h10/ud710_10h10_native.mk \
        ud710_2c11_native:$(LOCAL_DIR)/ud710_2c11/ud710_2c11_native.mk \
        ud710_7h10_native:$(LOCAL_DIR)/ud710_7h10/ud710_7h10_native.mk \
        ud710_2h10u_native:$(LOCAL_DIR)/ud710_2h10u/ud710_2h10u_native.mk \
	ud710_3h10u_native:$(LOCAL_DIR)/ud710_3h10u/ud710_3h10u_native.mk \
        ud710_9h10u_native:$(LOCAL_DIR)/ud710_9h10u/ud710_9h10u_native.mk \
        ud710_20c11_native:$(LOCAL_DIR)/ud710_20c11/ud710_20c11_native.mk \
        ud710_2h10_oversea:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_oversea.mk \
        ud710_2h10_true:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_true.mk \
        ud710_2h10_cmcc:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_cmcc.mk \
        ud710_2h10_ctcc:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_ctcc.mk \
        ud710_2h10_cucc:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_cucc.mk \
        ud710_2h10_ais:$(LOCAL_DIR)/ud710_2h10/ud710_2h10_ais.mk \
        ud710_7h10_ctcc:$(LOCAL_DIR)/ud710_7h10/ud710_7h10_ctcc.mk \
        ud710_7h10_cucc:$(LOCAL_DIR)/ud710_7h10/ud710_7h10_cucc.mk \
        ud710_7h10_cmcc:$(LOCAL_DIR)/ud710_7h10/ud710_7h10_cmcc.mk \
        ud710_20c11_cmcc:$(LOCAL_DIR)/ud710_20c11/ud710_20c11_cmcc.mk \
        ud710_20c11_cucc:$(LOCAL_DIR)/ud710_20c11/ud710_20c11_cucc.mk \
        ud710_20c11_ctcc:$(LOCAL_DIR)/ud710_20c11/ud710_20c11_ctcc.mk


COMMON_LUNCH_CHOICES := \
        ud710_2h10_native-userdebug-native \
        ud710_10h10_native-userdebug-native \
        ud710_2c11_native-userdebug-native \
        ud710_7h10_native-userdebug-native \
        ud710_7h10_ctcc-userdebug-native \
        ud710_7h10_cucc-userdebug-native \
        ud710_7h10_cmcc-userdebug-native \
        ud710_2h10u_native-userdebug-native \
        ud710_3h10u_native-userdebug-native \
        ud710_9h10u_native-userdebug-native \
        ud710_20c11_native-userdebug-native \
        ud710_2h10_oversea-userdebug-native \
        ud710_2h10_true-userdebug-native \
        ud710_2h10_cmcc-userdebug-native \
        ud710_2h10_ctcc-userdebug-native \
        ud710_2h10_cucc-userdebug-native \
        ud710_2h10_ais-userdebug-native \
        ud710_20c11_cmcc-userdebug-native \
        ud710_20c11_cucc-userdebug-native \
        ud710_20c11_ctcc-userdebug-native
