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

    Timer {
        id: timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            console.log("Timer triggered");
            positionSource.start();
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true

        Component.onCompleted: {
            console.log("PositionSource ready");
        }

        onSourceErrorChanged: {
            switch(sourceError) {
            case PositionSource.AccessError:
                console.log("AccessError"); break;
            case PositionSource.ClosedError:
                console.log("ClosedError"); break;
            case PositionSource.NoError:
                console.log("NoError"); break;
            case PositionSource.UnknownSourceError:
                console.log("UnknownSourceError"); break;
            case PositionSource.AccessError:
                console.log("SocketError"); break;
            }
            if(sourceError != PositionSource.NoError && sourceError != PositionSource.UnknownSourceError) {
                positionSource.stop();
                timer.start();
            }
        }

        onUpdateTimeout: {
            console.log("Update timeout");
        }

        onActiveChanged: {
            console.log("Active: " + active);
        }
    }

    StackView {
        id: stackView
        initialItem: "HomePage.qml"
        anchors.fill: parent
        Keys.onBackPressed: {
            console.log("Back button")
            if (depth > 1) {
                pop();
            } else {
                Qt.quit();
            }
        }
    }
}
