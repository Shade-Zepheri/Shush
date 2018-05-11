include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Shush
Shush_FILES = $(wildcard *.m)
Shush_INSTALL_PATH = /Library/PreferenceBundles
Shush_FRAMEWORKS = UIKit
Shush_PRIVATE_FRAMEWORKS = Preferences
Shush_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Shush.plist$(ECHO_END)
