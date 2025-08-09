#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    app.setApplicationName("BDA-Lab");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("Saiprasad Tech");
    app.setOrganizationDomain("saiprasad-tech.github.io");

    QQmlApplicationEngine engine;
    
    // Register QML import paths
    engine.addImportPath("qrc:/qml");
    
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}