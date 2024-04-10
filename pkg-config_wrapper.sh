#!/bin/sh
PKG_CONFIG_SYSROOT_DIR=/home/kikorik/QtFolder/Qt5.15.8_armV8/sysroot
export PKG_CONFIG_SYSROOT_DIR
PKG_CONFIG_LIBDIR=/home/kikorik/QtFolder/Qt5.15.8_armV8/sysroot/usr/lib/pkgconfig:/home/kikorik/QtFolder/Qt5.15.8_armV8/sysroot/usr/share/pkgconfig
export PKG_CONFIG_LIBDIR
exec pkg-config "$@"
