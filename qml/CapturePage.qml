import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import Spot 1.0
import QtQuick.Window 2.15

Page {
    title: "Capture"

    property Spot spot;

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

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
        orientation: {
            var o = camera.orientation;
            if(Screen.orientation == Qt.LandscapeOrientation) {
                o += 90;
            } else if(Screen.orientation == Qt.PortraitOrientation) {

            } else if(Screen.orientation == Qt.InvertedLandscapeOrientation) {
                o -= 90;
            } else if(Screen.orientation == Qt.InvertedPortraitOrientation) {
                o += 180;
            }

            o %= 360;

//            console.log("camera.orientation")
//            console.log(camera.orientation)
//            console.log("Screen.orientation")
//            console.log(Screen.orientation)
//            console.log("orientation")
//            console.log(o)
            return o;
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                console.log("camera onClicked")
                camera.imageCapture.capture();
            }
        }
    }
}
