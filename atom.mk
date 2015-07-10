LOCAL_PATH := $(call my-dir)
###############################################################################
# ArduCopter
###############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := arducopter
LOCAL_MODULE_FILENAME := arducopter
LOCAL_DESCRIPTION := ArduCopter is an open source autopilot

ARDUCOPTER_BUILD_DIR := $(call local-get-build-dir)
ARDUCOPTER_TOOLCHAIN_BIN_DIR := $(dir $(TARGET_CC_PATH))
ARDUCOPTER_FILENAME := $(LOCAL_MODULE_FILENAME)

# forward versosity to Ardupilot Makefile
ifneq ("$(V)","0")
	ARDUCOPTER_VERBOSE=1
else
	ARDUCOPTER_VERBOSE=
endif

# always enter in arducopter makefile
$(ARDUCOPTER_BUILD_DIR)/$(ARDUCOPTER_FILENAME): .FORCE
$(ARDUCOPTER_BUILD_DIR)/$(ARDUCOPTER_FILENAME):
	@mkdir -p $(ARDUCOPTER_BUILD_DIR)
	$(Q) PATH=$(ARDUCOPTER_TOOLCHAIN_BIN_DIR):$(PATH) BUILDROOT=$(ARDUCOPTER_BUILD_DIR) \
		$(MAKE) -C $(PRIVATE_PATH)/ArduCopter VERBOSE=$(ARDUCOPTER_VERBOSE) bebop
	$(Q) cp -af $(ARDUCOPTER_BUILD_DIR)/ArduCopter.elf $(ARDUCOPTER_BUILD_DIR)/$(ARDUCOPTER_FILENAME)
	@mkdir -p $(TARGET_OUT_STAGING)/usr/bin/
	$(Q) cp -af $(ARDUCOPTER_BUILD_DIR)/$(ARDUCOPTER_FILENAME) $(TARGET_OUT_STAGING)/usr/bin/$(ARDUCOPTER_FILENAME)

.PHONY: $(LOCAL_MODULE)-clean
$(LOCAL_MODULE)-clean:
	$(Q) PATH=$(ARDUCOPTER_TOOLCHAIN_BIN_DIR):$(PATH) BUILDROOT=$(ARDUCOPTER_BUILD_DIR) \
		$(MAKE) -C $(PRIVATE_PATH)/ArduCopter VERBOSE=$(ARDUCOPTER_VERBOSE) clean
	$(Q) rm -f $(ARDUCOPTER_BUILD_DIR)/$(ARDUCOPTER_FILENAME)
	$(Q) rm -f $(TARGET_OUT_STAGING)/usr/bin/$(ARDUCOPTER_FILENAME)

include $(BUILD_CUSTOM)

