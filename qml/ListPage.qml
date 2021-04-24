import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Page {
    title: "List"

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: AppInstance.spots
        delegate: SwipeDelegate {
            id: swipeDelegate
            property var spot: AppInstance.spots[index]
            text: spot.name
            width: listView.width
            leftPadding: 50

            onClicked: {
                swipe.close();
                stackView.push("SpotPage.qml", { "spot": spot })
            }

            ListView.onRemove: SequentialAnimation {
                PropertyAction {
                    target: swipeDelegate
                    property: "ListView.delayRemove"
                    value: true
                }
                NumberAnimation {
                    target: swipeDelegate
                    property: "height"
                    to: 0
                    easing.type: Easing.InOutQuad
                }
                PropertyAction {
                    target: swipeDelegate
                    property: "ListView.delayRemove"
                    value: false
                }
            }

            swipe.right: Label {
                id: deleteLabel
                text: qsTr("Delete")
                color: "white"
                verticalAlignment: Label.AlignVCenter
                padding: 12
                height: parent.height
                anchors.right: parent.right

                SwipeDelegate.onClicked: AppInstance.deleteSpot(spot.uuid)

                background: Rectangle {
                    color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                }
            }
        }

        RoundButton {
            id: addSpot
            width: 40
            height: 40
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            Material.background: Material.backgroundColor

            icon.source: "qrc:/icons/FontAwesome/fa-plus.svg"
            onClicked: {
                var spot = AppInstance.addSpot(positionSource.position.coordinate);
                stackView.push("SpotPage.qml", { "spot": spot })
            }
        }
    }
}
