#include "asynchimageio.h"

#if defined(Q_OS_IOS)
#include "nsassetmanager.h"
// #include "qml2mac_ios.h"
#endif


AsynchImageIO::AsynchImageIO( QObject *parent ) :
    QObject( parent )
{ }

AsynchImageIO::~AsynchImageIO()
{ }

void AsynchImageIO::save(const QImage &img, const QString &path)
{
    m_img  = img;
    m_path = path;
}

void AsynchImageIO::exec()
{

#if defined(Q_OS_IOS)
    NSAssetManager mgr;
    mgr.saveImage( m_img, "Test-App" );
    // saveToGalleryIOS( m_img );
#else
    m_img.save( m_path );
#endif

    emit done();
}
