# IPHONEOS ARMv7

INCLUDEPATH += $$PWD/src

# ICONS
# icons.path   = /
# icons.files += $$files($$PWD/icons/*.png)
# QMAKE_BUNDLE_DATA += icons
# QMAKE_INFO_PLIST  += $$PWD/manifest/Info.plist


LIBS   += \
    -framework UIKit \
    -framework AssetsLibrary

HEADERS += \
    $$PWD/src/nsassetmanager.h

OBJECTIVE_HEADERS += \
    $$PWD/src/nsstringext.h \
    $$PWD/src/nsassetmanager_p.h

OBJECTIVE_SOURCES += \
    $$PWD/src/nsstringext.mm \
    $$PWD/src/nsassetmanager.mm \
    $$PWD/src/nsassetmanager_p.m

