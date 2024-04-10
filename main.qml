import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Extras 1.4





ApplicationWindow {
    id: root
    width: 1280
    height: 800
    visible: true
    color: "Black"



    Loader {
        id: mainPageTopLoader
        asynchronous: true
        active: false
        anchors {
            fill: parent
        }
//        active: false
//        source: "qrc:/UI/WorkScreen/WorkScreenTOP.qml"

    }
    Rectangle {
        id: startButton
        anchors.centerIn: parent
        width: 400
        height: 200
        color: "#585858"



        Button {
            id: startButtonButton
            anchors.fill: parent

            onClicked: {
                mainPageTopLoader.source="qrc:/WorkScreenTOP.qml"
                mainPageTopLoader.active=true
                startButton.visible=false
            }
        }
        Text {
            id: startButtonText
            anchors.centerIn: parent
            text: "WELCOME"
            color: "red"

        }
    }
}
