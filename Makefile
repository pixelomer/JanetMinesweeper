TARGET := iphone:clang:latest:7.0
ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JanetMinesweeper

JanetMinesweeper_FILES = Tweak.x
JanetMinesweeper_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
