QT += core quick qml
QT += serialport multimedia

CONFIG += c++11
#CONFIG += qmltypes  //другая версия подключения своих модулей
CONFIG += link_pkgconfig
CONFIG += disable-desktop
SOURCES += \
        BackEnd/pedal.cpp \
        BackEnd/socket.cpp \
        BackEnd/uartqmlbridge.cpp \
        main.cpp

#LIBS += -lgpiod

#DEFINES += GST_USE_UNSTABLE_API
RESOURCES += qml.qrc

#QML_IMPORT_NAME = LightSide //другая версия подключения своих модулей
#QML_IMPORT_MAJOR_VERSION = 1 //другая версия подключения своих модулей
INCLUDEPATH +=  BackEnd \
                "/usr/include"

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
#QML_DESIGNER_IMPORT_PATH =

QT_QPA_ENABLE_TERMINAL_KEYBOARD = 0


# Default rules for deployment.
#qnx: target.path = /tmp/$${TARGET}/bin
#else: unix:!android: target.path = /opt/$${TARGET}/bin
#!isEmpty(target.path): INSTALLS += target

target.path = /usr/share/qtpr
INSTALLS += target


HEADERS += \
    BackEnd/pedal.h \
    BackEnd/socket.h \
    BackEnd/uartqmlbridge.h

#DISTFILES += \
#    UI/Assets/CUT_SOUND.wav \
#    UI/Assets/DoublePedal.png \
#    UI/Assets/MONO_COAG_SOUND.wav \
#    UI/Assets/NoPedal.png \
#    UI/Assets/SinglePedal.png
