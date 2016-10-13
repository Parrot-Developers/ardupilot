LOCAL_PATH := $(call my-dir)

APM_COMMON_CATEGORY_PATH := apm

APM_COMMON_SRC_LIBRARY_DIRS := \
	$(shell cat $(LOCAL_PATH)/../../Tools/ardupilotwaf/directories_list) \
	AP_HAL_Linux \
	AP_HAL/utility

APM_COMMON_CXXFLAGS := \
	-D_GNU_SOURCE \
	-DCONFIG_HAL_BOARD=HAL_BOARD_LINUX \
	-DF_CPU= \
	-DGIT_VERSION=\"$(shell cd $(LOCAL_PATH); git rev-parse --short=8 HEAD)\" \
	-DHAVE_CMATH_ISFINITE \
	-DHAVE_LIBDL \
	-DMAVLINK_PROTOCOL_VERSION=2 \
	-DNEED_CMATH_ISFINITE_STD_NAMESPACE \
	-DSKETCHBOOK="\"$(LOCAL_PATH)\"" \
	-fdata-sections \
	-ffunction-sections \
	-fno-exceptions \
	-fsigned-char \
	-std=gnu++11 \
	-Wno-missing-field-initializers \
	-Wno-overloaded-virtual \
	-Wno-reorder \
	-Wno-unknown-pragmas \
	-Wno-unknown-warning-option \
	-Wno-unused-parameter

APM_COMMON_C_INCLUDES := \
	$(LOCAL_PATH)/../../libraries/AP_Common/missing \
	$(LOCAL_PATH)/../../libraries/

APM_COMMON_LIBRARIES := \
	apm-mavlink-ardupilotmega \
	libiio

###############################################################################
# ArduCopter
###############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := arducopter
LOCAL_MODULE_FILENAME := arducopter
LOCAL_DESCRIPTION := ArduCopter is an open source autopilot
LOCAL_CATEGORY_PATH := $(APM_COMMON_CATEGORY_PATH)

$(call load-config)

LOCAL_CONFIG_FILES := Config.in

APM_COPTER_BEBOP_SRC_LIBRARY_DIRS := \
	$(APM_COMMON_SRC_LIBRARY_DIRS) \
	$(shell cat $(LOCAL_PATH)/../../ArduCopter/directories_list)

APM_COPTER_BEBOP_SRC_DIRS := \
	ArduCopter \
	$(addprefix libraries/,$(APM_COPTER_BEBOP_SRC_LIBRARY_DIRS))

LOCAL_SRC_FILES := \
	$(foreach dir,$(APM_COPTER_BEBOP_SRC_DIRS),$(call all-cpp-files-in,../../$(dir)))

ifeq ($(CONFIG_ARDUPILOT_MILOS),y)
LOCAL_COPY_FILES += ../Frame_params/Parrot_Bebop2.param:etc/arducopter/bebop.parm
else
LOCAL_COPY_FILES += ../Frame_params/Parrot_Bebop.param:etc/arducopter/bebop.parm
endif

LOCAL_CXXFLAGS := \
	$(APM_COMMON_CXXFLAGS) \
	-DSKETCH=\"ArduCopter\" \
	-DSKETCHNAME="\"ArduCopter\"" \
	-DAPM_BUILD_DIRECTORY=APM_BUILD_ArduCopter \
	-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_BEBOP

LOCAL_C_INCLUDES := \
	$(APM_COMMON_C_INCLUDES)

LOCAL_LIBRARIES := \
	$(APM_COMMON_LIBRARIES)

LOCAL_LDLIBS := \
	-ldl

include $(BUILD_EXECUTABLE)

###############################################################################
# APM:Plane, for disco
###############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := apm-plane-disco
LOCAL_MODULE_FILENAME := apm-plane-disco
LOCAL_DESCRIPTION := APM:Plane is an open source autopilot
LOCAL_CATEGORY_PATH := $(APM_COMMON_CATEGORY_PATH)

APM_PLANE_DISCO_SRC_LIBRARY_DIRS := \
	$(APM_COMMON_SRC_LIBRARY_DIRS) \
	$(shell cat $(LOCAL_PATH)/../../ArduPlane/directories_list)

APM_PLANE_DISCO_SRC_DIRS := \
	ArduPlane \
	$(addprefix libraries/,$(APM_PLANE_DISCO_SRC_LIBRARY_DIRS))

LOCAL_SRC_FILES := \
	$(foreach dir,$(APM_PLANE_DISCO_SRC_DIRS),$(call all-cpp-files-in,../../$(dir)))

LOCAL_CXXFLAGS := \
	$(APM_COMMON_CXXFLAGS) \
	-DSKETCH=\"ArduPlane\" \
	-DSKETCHNAME="\"ArduPlane\"" \
	-DAPM_BUILD_DIRECTORY=APM_BUILD_ArduPlane \
	-DCONFIG_HAL_BOARD_SUBTYPE=HAL_BOARD_SUBTYPE_LINUX_DISCO

LOCAL_C_INCLUDES := \
	$(APM_COMMON_C_INCLUDES)

LOCAL_LIBRARIES := \
	$(APM_COMMON_LIBRARIES)

LOCAL_COPY_FILES = \
	../Frame_params/Parrot_Disco/Parrot_Disco.param:etc/arduplane/disco.parm

LOCAL_LDLIBS := \
	-ldl

include $(BUILD_EXECUTABLE)

###############################################################################
# ardupilot headers
###############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := ardupilot-headers
LOCAL_DESCRIPTION := headers to be used by the export library
LOCAL_CATEGORY_PATH := $(APM_COMMON_CATEGORY_PATH)

LOCAL_EXPORT_C_INCLUDES := \
	$(LOCAL_PATH)/../../libraries/AP_Module/

include $(BUILD_CUSTOM)

