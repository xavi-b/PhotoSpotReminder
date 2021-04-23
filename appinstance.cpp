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
        new Spot("Front gps", this),
        new Spot("Rear gps", this),
        new Spot("Starboard gps", this),
        new Spot("Port gps", this),
        new Spot("Compass #1", this),
        new Spot("Compass #2", this),
        new Spot("Compass #3", this),
        new Spot("Compass #4", this),
        new Spot("Primary anemometer", this),
        new Spot("Secondary anemometer", this),
        new Spot("Main gyro", this),
        new Spot("Backup gyro", this)
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

void AppInstance::deleteSpot(QUuid const& uuid)
{
    this->spots.erase(std::find_if(this->spots.begin(), this->spots.end(), [uuid](auto const& e){
        return e->getUuid() == uuid;
    }));
    emit spotsChanged(this->spots);
}

void AppInstance::loadSpots()
{
    QFile file("fileName");

    if (!file.open(QIODevice::ReadOnly))
    {
        this->initTestSpots();
        //QMessageBox::warning(this, tr("Unable to spots file"), file.errorString(), tr("Ok"));
        return;
    }

    QDataStream in(&file);
    in >> this->spots;
}

void AppInstance::saveSpots()
{
    QFile file("fileName");

    if (!file.open(QIODevice::WriteOnly))
    {
        //QMessageBox::warning(this, tr("Unable to spots file"), file.errorString(), tr("Ok"));
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
