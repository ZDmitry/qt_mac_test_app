#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "testobj.h"

#include <qqml.h>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<TestObj>( "TestApp", 1, 0, "TestObj" );

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
