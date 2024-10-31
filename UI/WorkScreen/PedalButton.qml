import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import DarkSide 1.0

Rectangle {

    id: pedalButtonBack
    property SocketControl socket
    color:  Qt.rgba(0,0,0,0)
    radius: 10

    Popup {
        id: pedSelectPopup
        height: parent.height
        width: (parent.width + 12) * 3
        anchors.centerIn: parent
        background: Rectangle {
            anchors.fill: parent
            color: "black"
            border.width: 2
            border.color: "white"
            radius: 10
        }
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        }


        RowLayout {
            Rectangle {
                Layout.alignment: Qt.AlignCenter
                radius: 5
                color: pedalButtonBack.socket == singlePed.bindedSocket ? "white" : "gray"
                Layout.maximumWidth: (pedSelectPopup.width * 1/3)
                Layout.maximumHeight: pedSelectPopup.height
                Layout.preferredWidth:  (pedSelectPopup.width * 1/3) - 12
                Layout.preferredHeight: pedSelectPopup.height - 20
                Image {
                    id: popupSinglePed
                    source: "qrc:/UI/Assets/SinglePedal.png"
                    anchors {
                        fill: parent
                        centerIn: parent
                        margins: 5
                    }
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (pedalButtonBack.socket == doublePed.bindedSocket)  doublePed.setBindedSocket(null)
                        singlePed.setBindedSocket(pedalButtonBack.socket)
                        pedSelectPopup.close()
                    }
                }
            }
            Rectangle {
                Layout.alignment: Qt.AlignCenter
                radius: 5
                color: pedalButtonBack.socket == doublePed.bindedSocket ? "white" : "gray"
                Layout.maximumWidth: (pedSelectPopup.width * 1/3)
                Layout.maximumHeight: pedSelectPopup.height
                Layout.preferredWidth:  (pedSelectPopup.width * 1/3) - 12
                Layout.preferredHeight: pedSelectPopup.height - 20
                Image {
                    id: popupDoublePed
                    source: "qrc:/UI/Assets/DoublePedal.png"
                    anchors {
                        fill: parent
                        centerIn: parent
                        margins: 5
                    }
                    fillMode: Image.PreserveAspectFit

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (pedalButtonBack.socket == singlePed.bindedSocket)  singlePed.setBindedSocket(null)
                        doublePed.setBindedSocket(pedalButtonBack.socket)
                        pedSelectPopup.close()
                    }
                }
            }
            Rectangle {
                Layout.alignment: Qt.AlignCenter
                radius: 5
                color: pedalButtonBack.socket == null ? "white" : "gray"
                Layout.maximumWidth: (pedSelectPopup.width * 1/3)
                Layout.maximumHeight: pedSelectPopup.height
                Layout.preferredWidth:  (pedSelectPopup.width * 1/3) - 12
                Layout.preferredHeight: pedSelectPopup.height - 20
                Image {
                    id: popupNoPed
                    source: "qrc:/UI/Assets/NoPedal.png"
                    anchors {
                        fill: parent
                        centerIn: parent
                        margins: 5
                    }
                    fillMode: Image.PreserveAspectFit

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (pedalButtonBack.socket == singlePed.bindedSocket)  singlePed.setBindedSocket(null)
                        if (pedalButtonBack.socket == doublePed.bindedSocket)  doublePed.setBindedSocket(null)
                        pedSelectPopup.close()
                    }
                }
            }
        }
    }

    MouseArea {

        id: pedalButton
        anchors {
            fill: parent
        }

        onClicked: {
            pedSelectPopup.open()
        }
    }

    Image {
        id: pedalIcon
        source: {
            if (pedalButtonBack.socket == singlePed.bindedSocket) {
                return "qrc:/UI/Assets/SinglePedal.png"
            } else if (pedalButtonBack.socket == doublePed.bindedSocket){
                return "qrc:/UI/Assets/DoublePedal.png"
            } else {
                return "qrc:/UI/Assets/NoPedal.png"
            }
        }

        width: 87
        height: 74

        anchors {
            fill: parent
            centerIn: parent
        }
        fillMode: Image.PreserveAspectFit
    }
}
