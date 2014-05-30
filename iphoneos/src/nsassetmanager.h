#ifndef NSASSETMANAGER_H
#define NSASSETMANAGER_H

#ifdef __OBJC__
#define OBJC_CLASS(name) @class name;
#else
#define OBJC_CLASS(name) typedef struct objc_object name;
#endif

// fwd decl obj_c classes
OBJC_CLASS(NSAssetManagerPrivate)
OBJC_CLASS(UIImage)

// fwd decl carbon
typedef struct CGImage        *CGImageRef;
typedef struct CGDataProvider *CGDataProviderRef;

// Qt
#include <string>
#include <QObject>
#include <QString>
#include <QImage>


class NSAssetManager // : public QObject
{
    NSAssetManagerPrivate * m_d;

public:
    NSAssetManager( /* QObject* parent = 0 */ );
    ~NSAssetManager();

    void saveImage( UIImage* img, const std::string& album );

#ifdef QT_VERSION
    void saveImage( const QImage& img, const QString& album );
    // static void saveImage1( const QImage& img, const QString& album );

protected:
    static UIImage*  uiimage( const QImage& img );

private:
    static CGDataProviderRef CGDataProvider( const QImage& img );
#endif

};

#endif // NSASSETMANAGER_H
