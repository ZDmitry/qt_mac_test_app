#ifndef ASYNCHIMAGEIO_H
#define ASYNCHIMAGEIO_H

#include <QObject>
#include <QImage>


class AsynchImageIO : public QObject
{
    Q_OBJECT
public:
    AsynchImageIO( QObject *parent = 0 );
    ~AsynchImageIO();

    void save( const QImage& img, const QString& path );

signals:
    void done();

public slots:
    void exec();

private:
    QImage   m_img;
    QString  m_path;
};

#endif // ASYNCHIMAGEIO_H
