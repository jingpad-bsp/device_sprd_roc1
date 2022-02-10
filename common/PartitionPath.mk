
ifeq (ufs,$(strip $(BOARD_MEMORY_TYPE)))
PartitionPath := /dev/block/by-name
endif

ifeq (emmc,$(strip $(BOARD_MEMORY_TYPE)))
PartitionPath := /dev/block/by-name
endif