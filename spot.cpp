#include "spot.h"

Spot::Spot(QObject* parent)
    : QObject(parent), uuid(QUuid::createUuid())
{
}

Spot::Spot(QString name, QObject* parent)
    : QObject(parent), name(name), uuid(QUuid::createUuid())
{
}

QUuid Spot::getUuid() const
{
    return uuid;
}

QString Spot::getName() const
{
    return name;
}

QString Spot::getDescription() const
{
    return description;
}

QGeoCoordinate Spot::getCoordinate() const
{
    return coordinate;
}

QMap<QUuid, QPixmap> const& Spot::getPhotos() const
{
    return photos;
}

QStringList Spot::getPhotoKeys() const
{
    QStringList sources;
    for(auto const& key : this->photos.keys())
        sources.append("image://spots/"+this->uuid.toString()+'@'+key.toString());
    return sources;
}

void Spot::setName(QString const& name)
{
    this->name = name;
    emit nameChanged(name);
}

void Spot::setDescription(QString const& description)
{
    this->description = description;
    emit descriptionChanged(description);
}

void Spot::setCoordinate(QGeoCoordinate const& coordinate)
{
    this->coordinate = coordinate;
    emit coordinateChanged(coordinate);
}

QUuid Spot::addPhoto(QPixmap const& pixmap)
{
    QUuid uuid = QUuid::createUuid();
    this->photos.insert(uuid, pixmap);
    emit photosChanged(this->getPhotoKeys());
    return uuid;
}

void Spot::deletePhoto(QUuid const& uuid)
{
    this->photos.remove(uuid);
    emit photosChanged(this->getPhotoKeys());
}

QDataStream& operator<<(QDataStream& stream, Spot const& spot)
{
    stream << spot.uuid;
    stream << spot.name;
    stream << spot.description;
    stream << spot.coordinate;
    stream << spot.photos;
    return stream;
}

QDataStream& operator>>(QDataStream& stream, Spot& spot)
{
    stream >> spot.uuid;
    stream >> spot.name;
    stream >> spot.description;
    stream >> spot.coordinate;
    stream >> spot.photos;
    return stream;
}

QDataStream& operator<<(QDataStream& stream, Spot* const& spot)
{
    return stream << (*spot);
}

QDataStream& operator>>(QDataStream& stream, Spot*& spot)
{
    spot = new Spot();
    return stream >> (*spot);
}
