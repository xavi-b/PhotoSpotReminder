import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: Qt.application.name

    Plugin {
        id: mapPlugin
        name: "osm"

        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: "true"
        }
        PluginParameter {
            name: "osm.mapping.providersrepository.address"
            value: "http://maps-redirect.qt.io/osm/5.6/"
        }
    }

//    PositionSource {
//        id: positionSource
//        updateInterval: 500
//        active: false
//        //        name: "gpsd"
//        name: "fake"

//        PluginParameter { name: "port"; value: port }
//        PluginParameter { name: "host"; value: host }

//        Component.onCompleted: {
//            console.log("PositionSource ready");
//            positionSource.start();
//        }

//        onSourceErrorChanged: {
//            switch(sourceError) {
//            case PositionSource.AccessError:
//                console.log("AccessError"); break;
//            case PositionSource.ClosedError:
//                console.log("ClosedError"); break;
//            case PositionSource.NoError:
//                console.log("NoError"); break;
//            case PositionSource.UnknownSourceError:
//                console.log("UnknownSourceError"); break;
//            case PositionSource.AccessError:
//                console.log("SocketError"); break;
//            }

//        }

//        onUpdateTimeout: {
//            console.log("Update timeout");
//        }

//        onActiveChanged: {
//            console.log("Active: " + active);
//        }
//    }

    StackView {
        id: stackView
        initialItem: "HomePage.qml"
        anchors.fill: parent
    }
}
