QT += quick qml network positioning location widgets

CONFIG += c++11

SOURCES += \
        appinstance.cpp \
        main.cpp \
        spot.cpp

HEADERS += \
    appinstance.h \
    spot.h

RESOURCES += qml.qrc \
    icons.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

android: include(C:/Android/sdk/android_openssl/openssl.pri)
