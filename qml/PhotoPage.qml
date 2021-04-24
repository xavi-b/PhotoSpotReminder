import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Spot 1.0

Page {
    title: spot ? spot.name : "EMPTY"

    property Spot spot;
    property string photo;

    header: ToolBar {
        id: header
        contentHeight: toolButton.implicitHeight

        Label {
            text: spot.name
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            color: "white"
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
            icon.source: "qrc:/icons/FontAwesome/fa-trash.svg"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    spot.deletePhoto(photo);
                    stackView.pop();
                }
            }
        }
    }

    Image
    {
        anchors.fill: parent
        source: photo
        fillMode: Image.PreserveAspectFit
    }
}
