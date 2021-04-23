#ifndef SPOT_H
#define SPOT_H

#include <QObject>
#include <QGeoCoordinate>
#include <QPixmap>
#include <QUuid>
#include <QDataStream>
#include <QMap>

class Spot : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUuid uuid READ getUuid)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString description READ getDescription WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QGeoCoordinate coordinate READ getCoordinate WRITE setCoordinate NOTIFY coordinateChanged)
    Q_PROPERTY(QStringList photos READ getPhotoKeys NOTIFY photosChanged)

public:
    explicit Spot(QObject* parent = nullptr);
    explicit Spot(QString, QObject* parent = nullptr);

    QUuid getUuid() const;
    QString getName() const;
    QString getDescription() const;
    QGeoCoordinate getCoordinate() const;
    QMap<QUuid, QPixmap> const& getPhotos() const;
    QStringList getPhotoKeys() const;

    void setName(QString const&);
    void setDescription(QString const&);
    void setCoordinate(QGeoCoordinate const&);

    QUuid addPhoto(QPixmap const& pixmap);
    void deletePhoto(QUuid const& uuid);

    friend QDataStream& operator<<(QDataStream& stream, Spot const& spot);
    friend QDataStream& operator>>(QDataStream& stream, Spot& spot);
    friend QDataStream& operator<<(QDataStream& stream, Spot* const& spot);
    friend QDataStream& operator>>(QDataStream& stream, Spot*& spot);

signals:
    void nameChanged(QString const&);
    void descriptionChanged(QString const&);
    void coordinateChanged(QGeoCoordinate const&);
    void photosChanged(QStringList);

private:
    QUuid uuid;
    QString name = "Spot";
    QString description = "Spot description";
    QGeoCoordinate coordinate;
    QMap<QUuid, QPixmap> photos;
};

QDataStream& operator<<(QDataStream& stream, Spot const& spot);
QDataStream& operator>>(QDataStream& stream, Spot& spot);
QDataStream& operator<<(QDataStream& stream, Spot* const& spot);
QDataStream& operator>>(QDataStream& stream, Spot*& spot);

#endif // SPOT_H
