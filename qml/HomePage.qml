import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Shapes 1.15

Page {
    title: "Home"

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop();
                } else {
                    stackView.push("ListPage.qml")
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Map {
        id: map
        plugin: mapPlugin
        anchors.fill: parent

        Component.onCompleted: {
            positionSource.firstPositionUpdated.connect(function(){
                map.center = positionSource.position.coordinate
            });
        }

        Behavior on center {
            CoordinateAnimation {
                duration: driver.timerInterval
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on bearing {
            RotationAnimation {
                id: rot_anim
                direction: RotationAnimation.Shortest
                easing.type: Easing.Linear
                duration: driver.timerInterval
            }
        }

        property var currentIndexCoordinate;
        property var mapCenter;

        MapQuickItem {
            id: poiCurrent
            sourceItem: Rectangle {
                width: 14;
                height: 14;
                color: "red";
                border.width: 2;
                border.color: "white";
                smooth: true;
                radius: 7;
            }
            opacity: 1.0
            anchorPoint: Qt.point(sourceItem.width/2, sourceItem.height/2)
            coordinate: positionSource.position.coordinate
        }

        MapItemView {
            id: mapItemView
            model: AppInstance.spots
            //autoFitViewport: true
            delegate: MapQuickItem {
                property var spot: AppInstance.spots[index]
                id: point
                sourceItem: Rectangle {
                    width: 14;
                    height: 14;
                    color: "#1e25e4";
                    border.width: 2;
                    border.color: "white";
                    smooth: true;
                    radius: 7;

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            stackView.push("SpotPage.qml", { "spot" : spot })
                        }
                    }
                }
                opacity: 1.0
                anchorPoint: Qt.point(sourceItem.width/2, sourceItem.height/2)
                coordinate: spot.coordinate
            }
        }

        RoundButton {
            id: addButton
            width: 40
            height: 40
            anchors.right: parent.right
            anchors.bottom: compassButton.top
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            Material.background: Material.backgroundColor

            icon.source: "qrc:/icons/FontAwesome/fa-plus.svg"
            onClicked: {
                var spot = AppInstance.addSpot(positionSource.position.coordinate);
                stackView.push("SpotPage.qml", { "spot": spot })
            }
        }

        RoundButton {
            id: compassButton
            width: 40
            height: 40
            anchors.right: parent.right
            anchors.bottom: centerOnPositionButton.top
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            Material.background: Material.backgroundColor

            icon.source: "qrc:/icons/FontAwesome/fa-compass.svg"
            icon.height: height
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                map.bearing = 0;
            }
        }

        RoundButton {
            id: centerOnPositionButton
            width: 40
            height: 40
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            Material.background: Material.backgroundColor

            icon.source: "qrc:/icons/FontAwesome/fa-dot-circle.svg"
            onClicked: {
                map.center = positionSource.position.coordinate;
            }
        }
    }
}
