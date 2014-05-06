export TARGET = :clang
export ARCHS = armv7 arm64

include /opt/theos/makefiles/common.mk

BUNDLE_NAME = IRKitforProWidgets
IRKitforProWidgets_FILES = IRKitforProWidgets.m ViewController.m DetailViewController.m UIImage+IRKit.m
IRKitforProWidgets_FRAMEWORKS = UIKit QuartzCore
IRKitforProWidgets_LIBRARIES = prowidgets objcipc
IRKitforProWidgets_INSTALL_PATH = /Library/ProWidgets/Widgets/
IRKitforProWidgets_BUNDLE_EXTENSION = widget

include $(THEOS_MAKE_PATH)/bundle.mk

SUBPROJECTS = IRKitSubstrate

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 backboardd"