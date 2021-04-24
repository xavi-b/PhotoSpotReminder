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
                    stackView.pop();
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
                console.log("onImageCaptured")
                console.log(preview)
                //AppInstance.addPhoto(spot, preview);
                previewImage.source = preview;
                previewImage.grabToImage(function(result) {
                    console.log("grabToImage")
                    console.log(result)
                    spot.addPhoto(result);
                    if (stackView.depth > 1) {
                        stackView.pop();
                    }
                });
            }
        }
    }

    Image {
        id: previewImage
        visible: false
    }

    VideoOutput {
        source: camera
        focus : visible
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                console.log("camera onClicked")
                camera.imageCapture.capture();
            }
        }
    }
}
