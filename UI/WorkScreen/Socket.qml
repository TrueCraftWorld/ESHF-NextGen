import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12
import QtMultimedia 5.15
import DarkSide 1.0

Rectangle {
    id: socket
    required property SocketControl socketIndex
    anchors {

        margins: 7
    }
    width: .5 * (parent.width-20)
    height: .5 * (parent.height-20)

    radius: 10

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#888888" }
        GradientStop { position: 1.0; color: "#303030" }
    }


    ModeButton {
        id: coagMode
        anchors {
            right: socket.right
            leftMargin: 5
            topMargin: 10
            rightMargin: 10
            left: socket.horizontalCenter
            bottom: socket.verticalCenter
            top: socket.top
            bottomMargin: 30
        }
        modeIndex: socketIndex.getCoagMode(socketIndex.coagModeIndex)
        parentSocket: socketIndex
        isCoag: true
    }

    ModeButton {
        id: cutMode
        anchors {
            leftMargin: 10
            topMargin: 10
            rightMargin: 5
            left: socket.left
            right: socket.horizontalCenter
            bottom: socket.verticalCenter
            top: socket.top
            bottomMargin: 30

        }
        modeIndex: socketIndex.getCutMode(socketIndex.cutModeIndex)
        parentSocket: socketIndex
        isCoag: false
    }

    Text {
        id: socketNameText
        color: "white"
        width: parent.width
        height: 64
        anchors {
            top: coagMode.bottom
            left: parent.left
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 28
        text:  socketIndex.socketName
    }

    RowLayout {
        id: lowerButtons
        anchors {
            top: socketNameText.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: 20
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 10

        Rectangle {
            id: instrumButton1
            Layout.preferredHeight: 130
            Layout.preferredWidth: (parent.width - parent.spacing*2 - parent.anchors.margins*2) * 1/3
            color:  Qt.rgba(0,0,0,0)
            border.width: 2
            border.color: "white"
            radius: 10
        }

        PedalButton {
            id: pedalButtonBack
            socket: socketIndex
            Layout.preferredHeight: 130
            Layout.preferredWidth: (parent.width - parent.spacing*2 - parent.anchors.margins*2) * 1/3
        }

        Rectangle {
            id: instrumButton2
            Layout.preferredHeight: 130
            Layout.preferredWidth: (parent.width - parent.spacing*2 - parent.anchors.margins*2) * 1/3
            color:  Qt.rgba(0,0,0,0)
            border.width: 2
            border.color: "white"
            radius: 10
        }
    }
    Rectangle {

        id: activationPlate
        property bool isCoagActiv: (socketIndex.socketStatus === SocketControl.S_ACTIVE_COAG) ? true : false
        property EshfMode activMode: {
            if (activationPlate.isCoagActiv) return socketIndex.getCoagMode(socketIndex.coagModeIndex)
            else return socketIndex.getCutMode(socketIndex.cutModeIndex)
        }

        visible: ((socketIndex.socketStatus === SocketControl.S_ACTIVE_COAG) || (socketIndex.socketStatus === SocketControl.S_ACTIVE_CUT))
        anchors.fill: parent
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: activationPlate.isCoagActiv ? "#1F78FC" : "#FFE600" }
            GradientStop { position: 1.0; color: activationPlate.isCoagActiv ? "#0049B6" : "#C09D00" }
        }
        Text {
            id: activeMode
            text: activationPlate.activMode.modeName
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 50
            }
            font {
                pixelSize: 52
                bold: true
            }
            color: activationPlate.isCoagActiv ? "white" : "black"
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            id: activePower
            text: activationPlate.activMode.currentPower.toString()
            anchors {
                top: activeMode.bottom
                left: parent.left
                right: parent.right
                topMargin: 100
            }
            font {
                pixelSize: 80
                bold: true
            }
            color: activationPlate.isCoagActiv ? "white" : "black"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
