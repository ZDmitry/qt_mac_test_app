#ifndef TESTOBJ_H
#define TESTOBJ_H

#include <QObject>

class TestObj : public QObject
{
    Q_OBJECT

public:
    TestObj( QObject *parent = 0 );

public slots:
    void click();

};

#endif // TESTOBJ_H
