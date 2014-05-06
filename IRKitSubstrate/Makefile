export TARGET = :clang
ARCHS = armv7 armv7s arm64

include /opt/theos/makefiles/common.mk

TWEAK_NAME = IRKitSubstrate
IRKitSubstrate_FILES = IRKitSubstrate.xm
IRKitSubstrate_FRAMEWORKS = UIKit
IRKitSubstrate_LIBRARIES = objcipc

include $(THEOS_MAKE_PATH)/tweak.mk