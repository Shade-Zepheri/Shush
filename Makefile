export TARGET = iphone:11.2:9.0

INSTALL_TARGET_PROCESSES = SpringBoard

export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -IHeaders -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Shush
Shush_FILES = $(wildcard *.x)
Shush_LIBRARIES = flipswitch
Shush_CFLAGS = -IHeaders

include $(THEOS_MAKE_PATH)/tweak.mk
