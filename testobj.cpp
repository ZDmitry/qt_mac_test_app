#include "testobj.h"
#include "asynchimageio.h"

#include <QThread>
#include <QImage>
#include <QPixmap>
#include <QDebug>


TestObj::TestObj(QObject *parent) :
    QObject(parent)
{ }

void TestObj::click()
{
    qDebug() << "TestObj::click()";

    AsynchImageIO* imgio = new AsynchImageIO();

    QThread* thread = new QThread();
    imgio->moveToThread( thread );

    connect( thread,  SIGNAL(finished()), thread,  SLOT(deleteLater()) );
    connect( thread,  SIGNAL(started()),  imgio,   SLOT(exec()) );

    connect( imgio,   SIGNAL(done()),     thread,  SLOT(quit()) );
    connect( imgio,   SIGNAL(done()),     imgio,   SLOT(deleteLater()) );

    QPixmap pm( 100, 100 );
    pm.fill( Qt::darkRed );
    imgio->save( pm.toImage(), "path" );
    // imgio->exec();
    
    thread->start();
    // thread->deleteLater();
}
