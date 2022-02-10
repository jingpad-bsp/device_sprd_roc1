CUR_PATH := device/sprd/roc1/ud710_2h10u/jingos/bootanimation

ifeq ($(strip $(LATTICE_SUPPORT)),true)
	PRODUCT_PACKAGES += bootanimation.lattice
else
	PRODUCT_PACKAGES += bootanimation.jingos
endif


