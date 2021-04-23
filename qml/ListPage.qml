import QtQuick 2.15
import QtQuick.Controls 2.15

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
        delegate: ItemDelegate {
            property var spot: AppInstance.spots[index]
            text: spot.name
            width: listView.width
            leftPadding: 50
            onClicked: {
                stackView.push("SpotPage.qml", { "spot": spot })
            }
        }
    }
}
