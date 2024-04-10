import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: message
    property string messageContent
    property int messageType
    signal destroyMe()

    anchors.fill: parent

    MouseArea {
        anchors.fill: parent
        onClicked: message.destroyMe()
    }


    Rectangle {
        id: messageBackGround
        width: parent.width/2
        height: parent.height/2
        anchors.centerIn: parent
        color: "gray"
        radius: 10
        border {
            color: {
                if (message.messageType === 0) return "red"
                if (message.messageType === 1) return "yellow"
                if (message.messageType === 2) return "green"
                return "black"
            }
            width: 5
        }
        Text {
            id: messageText
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: closeButton.top
                margins: 25
            }
            font {
                pixelSize: 24
                bold: true
            }
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            text: messageContent

        }

        Button {
            id: closeButton
            width: parent.width/3
            height: 80
            anchors {
                bottom: parent.bottom
                bottomMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            onClicked: message.destroyMe()
            background: Rectangle {
                anchors.fill: parent
                color: "white"
                radius: 10
                Text {
                    text: "OK!"
                    anchors.fill: parent
                    font {
                        pixelSize: 24
                        bold: true
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                }

            }
        }
    }
}
