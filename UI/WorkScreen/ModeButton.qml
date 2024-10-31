import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import DarkSide 1.0
//Item {

Rectangle {
    id: mode

    function valueByIndex(x) {
        var table = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                     22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,
                     55,60,65,70,75,80,85,90,95,100,
                     110,120,130,140,150,160,170,180,190,200,
                     225,250,275,300,325,350,375,400];

        return table[x];
    }
    function valueIndex(val) {
        var index;

        for (index = 0; index < 64; index++) {
          if (value(index) === val) return index;
        }
        return 0;
    }

    property EshfMode modeIndex
    property SocketControl parentSocket
    property bool isCoag


    radius: 10

    gradient: Gradient {
        GradientStop { position: 0.0; color: isCoag ? "#1F78FC" : "#FFE600" }
        GradientStop { position: 1.0; color: isCoag ? "#0049B6" : "#C09D00" }
    }

    Text {
        id: modeNameText
        color: isCoag ? "white" : "black"
        width: parent.width
        anchors {
            topMargin: 5
            top: parent.top
            left: parent.left
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
        text:  modeIndex.modeName

        MouseArea {
            id: modeSelectButtonRight
            anchors {

                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width *.25
            onClicked: {

                isCoag ? parentSocket.coagModeIndex++ :  parentSocket.cutModeIndex++
//                mode.update()
            }
        }
        MouseArea {
            id: modeSelectButtonLeft

            anchors {
                left: parent.left

                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width *.25
            onClicked: {

                if (isCoag) {
                    if ( parentSocket.coagModeIndex !== 0 )
                        parentSocket.coagModeIndex--;
                } else {
                    if ( parentSocket.cutModeIndex !== 0)
                        parentSocket.cutModeIndex--;
                }
            }
        }
    }


    Rectangle {
        id: modeNameUnderLine
        color: isCoag ? "white" : "black"
        width: parent.width
        height: 2
        anchors {
            top: modeNameText.bottom
            topMargin: 8
            left: parent.left
        }
    }

    Text {
        id: modePowerText
        color: isCoag ? "white" : "black"
        width: parent.width
        anchors {
            topMargin: 10
            top: modeNameText.bottom
            left: parent.left
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 50
        text:  modeIndex.currentPower.toString()

    }

    PowerSlider {
        id: powerSlider
        maxValue: modeIndex.maximumPower
        value: valueIndex(modeIndex.currentPower)
        type: isCoag ? 1 : 0
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: 1
            rightMargin: 5
            leftMargin: 5
        }
        onMoved: modeIndex.currentPower = valueByIndex(powerSlider.value)

    }
    Rectangle {
        visible: (modeIndex.modeName === "NO MODE") ? true : false
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: modeNameUnderLine.top
        }
        color: "gray"
        radius: parent.radius
        Rectangle {
            visible: parent.visible
            anchors.top: parent.top
            height: parent.radius
            width: parent.width
            color: parent.color
        }
    }
}
