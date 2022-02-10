LOCAL_PATH := $(call my-dir)

####### so #########
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/libc++_shared.so:system/lib/libc++_shared.so
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/libNewtranxMTjni.so:system/lib/libNewtranxMTjni.so
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/libNewtranxMT.so:system/lib/libNewtranxMT.so

####### en2zh #########
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2zh/en.bpe:system/usr/share/mt2_engine/en2zh/en.bpe
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2zh/model.yml:system/usr/share/mt2_engine/en2zh/model.yml
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2zh/s.model.bin:system/usr/share/mt2_engine/en2zh/s.model.bin
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2zh/vocab.en.txt:system/usr/share/mt2_engine/en2zh/vocab.en.txt
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2zh/vocab.zh.txt:system/usr/share/mt2_engine/en2zh/vocab.zh.txt

####### zh2en #########
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/zh.bpe:system/usr/share/mt2_engine/zh2en/zh.bpe
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/model.yml:system/usr/share/mt2_engine/zh2en/model.yml
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/s.model.bin:system/usr/share/mt2_engine/zh2en/s.model.bin
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/vocab.en.txt:system/usr/share/mt2_engine/zh2en/vocab.en.txt
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/vocab.zh.txt:system/usr/share/mt2_engine/zh2en/vocab.zh.txt

PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/hmm_model.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/hmm_model.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/idf.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/idf.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/jieba.dict.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/jieba.dict.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/README.md:system/usr/share/mt2_engine/zh2en/debian/dict/README.md
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/stop_words.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/stop_words.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/user.dict.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/user.dict.utf8

PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/pos_dict/char_state_tab.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/pos_dict/char_state_tab.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/pos_dict/prob_emit.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/pos_dict/prob_emit.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/pos_dict/prob_start.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/pos_dict/prob_start.utf8
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/zh2en/debian/dict/pos_dict/prob_trans.utf8:system/usr/share/mt2_engine/zh2en/debian/dict/pos_dict/prob_trans.utf8

####### en2ja #########
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2ja/enja.bpe:system/usr/share/mt2_engine/en2ja/enja.bpe
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2ja/log:system/usr/share/mt2_engine/en2ja/log
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2ja/model.yml:system/usr/share/mt2_engine/en2ja/model.yml
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2ja/s.model.bin:system/usr/share/mt2_engine/en2ja/s.model.bin
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2ja/vocab.en.txt:system/usr/share/mt2_engine/en2ja/vocab.en.txt
PRODUCT_COPY_FILES += device/sprd/roc1/ud710_2h10u/jingos/translation/mt2_engine/en2ja/vocab.ja.txt:system/usr/share/mt2_engine/en2ja/vocab.ja.txt


# PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(LOCAL_PATH)/mt2_engine,system/usr/share)


