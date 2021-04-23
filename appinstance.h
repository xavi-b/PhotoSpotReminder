#ifndef APPINSTANCE_H
#define APPINSTANCE_H

#include <QObject>
#include <QQuickImageProvider>
#include "spot.h"

class AppInstance : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(QList<Spot*> spots READ getSpots NOTIFY spotsChanged)

public:
    explicit AppInstance(QObject* parent = nullptr);
    ~AppInstance();
    void initTestSpots();
    QList<Spot*> const& getSpots() const;

    void loadSpots();
    void saveSpots();

    QQmlImageProviderBase::ImageType imageType() const override;
    QPixmap requestPixmap(const QString& id, QSize* size, const QSize& requestedSize) override;

signals:
    void spotsChanged(QList<Spot*> const&);

private:
    QList<Spot*> spots;
};

#endif // APPINSTANCE_H
