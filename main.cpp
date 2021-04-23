#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "spot.h"
#include "appinstance.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    AppInstance* manager = new AppInstance;
    manager->loadSpots();

    qmlRegisterType<Spot>("Spot", 1, 0, "Spot");

    QQmlApplicationEngine engine;
    engine.addImageProvider("spots", manager);
    engine.rootContext()->setContextProperty("AppInstance", manager);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    QObject::connect(&app, &QGuiApplication::aboutToQuit, manager, &AppInstance::saveSpots);

    return app.exec();
}
