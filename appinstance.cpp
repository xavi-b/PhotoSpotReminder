#include "appinstance.h"
#include <QFile>
#include <QMessageBox>

AppInstance::AppInstance(QObject* parent)
    : QObject(parent), QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

AppInstance::~AppInstance()
{
    qDeleteAll(this->spots);
    this->spots.clear();
}

void AppInstance::initTestSpots()
{
    this->spots = {
        new Spot(this),
        new Spot(this),
        new Spot(this)
    };
    QPixmap pixmap(100, 100);
    pixmap.fill(Qt::red);
    this->spots.at(0)->addPhoto(pixmap);
    pixmap.fill(Qt::blue);
    this->spots.at(0)->addPhoto(pixmap);
    pixmap.fill(Qt::yellow);
    this->spots.at(0)->addPhoto(pixmap);
    pixmap.fill(Qt::red);
    this->spots.at(0)->addPhoto(pixmap);
    pixmap.fill(Qt::blue);
    this->spots.at(0)->addPhoto(pixmap);
    pixmap.fill(Qt::yellow);
    this->spots.at(0)->addPhoto(pixmap);
    pixmap.fill(Qt::green);
    this->spots.at(1)->addPhoto(pixmap);
    emit spotsChanged(this->spots);
}

QList<Spot*>& AppInstance::getSpots()
{
    return this->spots;
}

Spot* AppInstance::addSpot(QGeoCoordinate const& coordinate)
{
    this->spots.append(new Spot(this));
    this->spots.last()->setCoordinate(coordinate);
    emit spotsChanged(this->spots);
    return this->spots.last();
}

void AppInstance::deleteSpot(QUuid const& uuid)
{
    this->spots.erase(std::find_if(this->spots.begin(), this->spots.end(), [uuid](Spot* const& e){
        return e->getUuid() == uuid;
    }));
    emit spotsChanged(this->spots);
}

void AppInstance::loadSpots()
{
    //TODO
    QFile file("fileName");

    if (!file.open(QIODevice::ReadOnly))
    {
        this->initTestSpots();
        //QMessageBox::warning(this, tr("Unable to spots file"), file.errorString(), tr("Ok"));
        qWarning() << "Unable to spots file";
        return;
    }

    QDataStream in(&file);
    in >> this->spots;
}

void AppInstance::saveSpots()
{
    //TODO
    QFile file("fileName");

    if (!file.open(QIODevice::WriteOnly))
    {
        //QMessageBox::warning(this, tr("Unable to spots file"), file.errorString(), tr("Ok"));
        qWarning() << "Unable to spots file";
        return;
    }

    QDataStream out(&file);
    out << this->spots;
}

QQmlImageProviderBase::ImageType AppInstance::imageType() const
{
    return QQmlImageProviderBase::ImageType::Pixmap;
}

QPixmap AppInstance::requestPixmap(const QString& id, QSize* size, const QSize& requestedSize)
{
    QString cleaned(id);
    cleaned.replace("%7B", "{");
    cleaned.replace("%7D", "}");
    QStringList uuids = cleaned.split('@');

    if(uuids.size() == 2)
    {
        auto spotUuid = uuids[0];
        auto photoUuid = uuids[1];

        for(auto const& spot : this->spots)
        {
            if(spot->getUuid() == spotUuid)
            {
                for(auto const& photoKey : spot->getPhotos().keys())
                {
                    if(photoKey == photoUuid)
                        return spot->getPhotos().value(photoKey);
                }
                break;
            }
        }
    }

    int v = 100;
    if (size)
        *size = QSize(v, v);
    QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : v,
                   requestedSize.height() > 0 ? requestedSize.height() : v);
    pixmap.fill(Qt::lightGray);
    return pixmap;
}
