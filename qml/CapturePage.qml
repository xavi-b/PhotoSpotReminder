import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import Spot 1.0

Page {
    title: "Capture"

    property Spot spot;

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

    Camera {
        id: camera

        imageCapture {
            onImageCaptured: {
                spot.addPhoto(preview);
                if (stackView.depth > 1) {
                    stackView.pop()
                }
            }
        }
    }

    VideoOutput {
        source: camera
        focus : visible
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent;
            onClicked: camera.imageCapture.capture();
        }
    }
}
