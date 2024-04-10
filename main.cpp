#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "BackEnd/socket.h"
#include "BackEnd/uartqmlbridge.h"
#include "BackEnd/pedal.h"


int main(int argc, char *argv[])
{
//    qputenv("QT_QPA_GENERIC_PLUGINS", QByteArray("evdevkeyboard"));
//    qputenv("QT_QPA_EVDEV_KEYBOARD_PARAMETERS", QByteArray("grab=1"));
//    qputenv("QT_QPA_EGLFS_HEIGHT", QByteArray("1280"));
//    qputenv("QT_QPA_EGLFS_WIDTH", QByteArray("800"));


#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    qputenv("QT_IM_MODULE", QByteArray("cutekeyboard"));
    QGuiApplication app(argc, argv);

    qmlRegisterUncreatableType< SOCKET >("DarkSide", 1, 0, "SocketControl", "blab1la");
    qmlRegisterUncreatableType< EshfMode >("DarkSide", 1, 0, "EshfMode", "blabla");
    qmlRegisterUncreatableType< PEDAL >("DarkSide", 1, 0, "PEDAL", "blabla");
    qmlRegisterUncreatableType< UartToQmlBridge >("DarkSide", 1, 0, "UART", "blabla");

    QQmlApplicationEngine engine;

    SOCKET* bipolar_1 = new SOCKET(SOCKET::BIPOLAR_1, &app);
    engine.rootContext()->setContextProperty("bi_1", bipolar_1);

    SOCKET* bipolar_2 = new SOCKET(SOCKET::BIPOLAR_2, &app);
    engine.rootContext()->setContextProperty("bi_2", bipolar_2);

    SOCKET* monopolar_1 = new SOCKET(SOCKET::MONOPOLAR_1, &app);
    engine.rootContext()->setContextProperty("mono_1", monopolar_1);

    SOCKET* monopolar_2 = new SOCKET(SOCKET::MONOPOLAR_2, &app);
    engine.rootContext()->setContextProperty("mono_2", monopolar_2);

    UartToQmlBridge* uart_comms = new UartToQmlBridge();
    engine.rootContext()->setContextProperty("uart", uart_comms);

    PEDAL* singlePedal = new PEDAL(PEDAL::SINGLE_PED);
    engine.rootContext()->setContextProperty("singlePed", singlePedal);

    PEDAL* doublePedal = new PEDAL(PEDAL::DOUBLE_PED);
    engine.rootContext()->setContextProperty("doublePed", doublePedal);

//    singlePedal->setBindedSocket(bipolar_1);
//    doublePedal->setBindedSocket(monopolar_2);

    QObject::connect(bipolar_1, &SOCKET::socketInfoUpdated, uart_comms, &UartToQmlBridge::writeData);
    QObject::connect(bipolar_2, &SOCKET::socketInfoUpdated, uart_comms, &UartToQmlBridge::writeData);
    QObject::connect(monopolar_1, &SOCKET::socketInfoUpdated, uart_comms, &UartToQmlBridge::writeData);
    QObject::connect(monopolar_2, &SOCKET::socketInfoUpdated, uart_comms, &UartToQmlBridge::writeData);
    QObject::connect(singlePedal, &PEDAL::pedalInfoUpdated, uart_comms, &UartToQmlBridge::writeData);
    QObject::connect(doublePedal, &PEDAL::pedalInfoUpdated, uart_comms, &UartToQmlBridge::writeData);
//    QObject::connect(uart_comms, &UartToQmlBridge::responseChanged, uart_comms, &UartToQmlBridge::writeData);


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
