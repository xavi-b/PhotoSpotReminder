import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Spot 1.0

Page {
    title: spot ? spot.name : "EMPTY"

    property Spot spot;

    header: ToolBar {
        id: header
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

    Rectangle
    {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: panel.top

        id: wrapper
        color: "orange"

        GridView {
            id: gridView
            anchors.fill: parent

            property var idealCellHeight: 200
            property var idealCellWidth: 200

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
        color: "white"

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
            text: "Button"
            Material.background: Material.backgroundColor

            onClicked: {
                if(parent.height > parent.initialHeight)
                    parent.height = parent.initialHeight;
                else
                    parent.height = 200;
            }
        }

        TextEdit {
            text: spot.description
            anchors.top: openBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
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

        icon.source: "qrc:/icons/FontAwesome/fa-dot-circle.svg"
        onClicked: {
            //TODO
        }
    }
}