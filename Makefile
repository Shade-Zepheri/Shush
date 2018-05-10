export TARGET = iphone:11.2:9.0

INSTALL_TARGET_PROCESSES = SpringBoard

export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Shush
Shush_FILES = $(wildcard *.x)
Shush_LIBRARIES = flipswitch

include $(THEOS_MAKE_PATH)/tweak.mk
