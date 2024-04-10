import QtQuick 2.0
import QtQuick.Controls 2.15

Slider {
    property int maxValue: 400
    property int type: 0

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
          if (valueByIndex(index) === val) return index;
        }
        return 0;
    }

    id: powerControlSlider
    value: 1
    stepSize: 1
    from: 0
    to: valueIndex(maxValue)
    background: Rectangle {
        x: powerControlSlider.leftPadding
        y: powerControlSlider.topPadding + powerControlSlider.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 6
        width: powerControlSlider.availableWidth
        height: implicitHeight
        radius: 2
        color: type === 0 ? "Yellow" : "Blue"
        border {
            color: type === 0 ? "Black" : "White"
        }

        Rectangle {
            width: powerControlSlider.visualPosition * parent.width
            height: parent.height
            color: type === 0 ? "Black" : "White"
            radius: 2
        }
    }

    handle: Rectangle {
        x: powerControlSlider.leftPadding + powerControlSlider.visualPosition * (powerControlSlider.availableWidth - width)
        y: powerControlSlider.topPadding + powerControlSlider.availableHeight / 2 - height / 2
        implicitWidth: 14
        implicitHeight: 14
        radius: 6
        color: type === 0 ? "Yellow" : "Blue"
        border.color: type === 0 ? "Black" : "White"
    }
}
