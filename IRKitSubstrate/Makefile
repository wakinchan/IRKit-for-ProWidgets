export TARGET = iphone:clang::7.0
export ARCHS = armv7 arm64
export GO_EASY_ON_ME = 1

include /opt/theos/makefiles/common.mk

TWEAK_NAME = IRKitSubstrate
IRKitSubstrate_FILES = IRKitSubstrate.xm
IRKitSubstrate_FRAMEWORKS = UIKit QuartzCore
IRKitSubstrate_LIBRARIES = objcipc

include $(THEOS_MAKE_PATH)/tweak.mk