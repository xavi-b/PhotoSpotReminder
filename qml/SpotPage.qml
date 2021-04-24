import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Spot 1.0

Page {
    title: spot ? spot.name : "EMPTY"

    //TODO share btn
    //TODO goTo btn

    property Spot spot;

    header: ToolBar {
        id: header
        contentHeight: toolButton.implicitHeight

        TextInput {
            text: spot.name
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            color: "white"
            onTextChanged: {
                spot.name = text;
            }
        }

        ToolButton {
            id: toolButton
            icon.source: {
                if(stackView.depth > 1) {
                    return "qrc:/icons/FontAwesome/fa-arrow-left.svg";
                } else {
                    return "qrc:/icons/FontAwesome/fa-bars.svg";
                }
            }
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop();
                }
            }
        }

        ToolButton {
            id: deleteButton
            anchors.right: parent.right
            text: "X"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    AppInstance.deleteSpot(spot.uuid);
                    stackView.pop();
                }
            }
        }
    }

    Rectangle
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: panel.top

        id: wrapper
        color: "transparent"

        GridView {
            id: gridView
            anchors.fill: parent

            property var idealCellHeight: 150
            property var idealCellWidth: 150

            cellHeight: idealCellHeight
            cellWidth: width / Math.floor(width / idealCellWidth)

            model: spot.photos
            delegate: Component {
                Item {
                    width: gridView.cellWidth
                    height: gridView.cellHeight
                    Rectangle {
                        width: gridView.idealCellWidth-5
                        height: gridView.cellHeight-5
                        anchors.centerIn: parent
                        Image {
                            anchors.fill: parent
                            source: spot.photos[index]
                            fillMode: Image.PreserveAspectCrop
                            clip: true
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: panel
        property int initialHeight: 50

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: initialHeight
        color: Material.backgroundColor

        Behavior on height {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
            }
        }

        Button {
            id: openBtn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.initialHeight
            Material.background: "transparent"
            icon.source: "qrc:/icons/FontAwesome/fa-chevron-up.svg"

            onClicked: {
                if(parent.height > parent.initialHeight) {
                    icon.source = "qrc:/icons/FontAwesome/fa-chevron-up.svg"
                    parent.height = parent.initialHeight;
                } else {
                    icon.source = "qrc:/icons/FontAwesome/fa-chevron-down.svg"
                    parent.height = 200;
                }
            }
        }

        TextEdit {
            text: spot.description
            anchors.top: openBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            color: "white"
            onTextChanged: {
                spot.description = text;
            }
        }
    }

    RoundButton {
        id: addPhoto
        width: 40
        height: 40
        anchors.right: parent.right
        anchors.bottom: wrapper.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
        Material.background: Material.backgroundColor

        icon.source: "qrc:/icons/FontAwesome/fa-plus.svg"
        onClicked: {
            stackView.push("CapturePage.qml", { "spot": spot })
        }
    }
}
