import QtQuick 2.15
//import DarkSide 1.0

Rectangle {
    id: statusBar

    //   property UART uartPointer
    function inputParser(input){
       var numbers = input.match(/\d/g);
       if (numbers === null) {
           const numbers2 = ["255", "255", "255","255", "255", "255"];
           return numbers2
       }
       if (numbers.length) numbers = numbers.join("");
       return numbers;
    }
    property var connStatusMsg: inputParser(uart.response.toString())
    height: parent.height * 1/15
    anchors {
       top: parent.top
       left: parent.left
       right: parent.right
    }
    color: "#585858"
    Text {
       id:test
       color: "white"
       font.pixelSize: 40
       font.italic: true
       anchors {
           fill: parent
       }
       text: "Hello World!"
       horizontalAlignment: Text.AlignHCenter

    }

    TextEdit{
        id:testKey
        height: parent.height
        width: 250
        text: "<b>Hello</b> <i>World!</i>"
        anchors {
            left: parent.left
        }
        color: "blue"

    }

    Rectangle {
       id: unitConnections

       width: 170
       height: 50
       anchors {
           top: parent.top
           right: parent.right
       }

       Rectangle {
           id: argConnection
           width: 50
           height: 50
           anchors {
               top: parent.top
               right: genConnection.left
               rightMargin: 10
           }
           color: {
               if (statusBar.connStatusMsg[0] === "255") return "black"
                if (statusBar.connStatusMsg[1] === "0")
                    return "red"
//                if (statusBar.connStatusMsg[1] === "2")
//                    return "magenta"
//                if (statusBar.connStatusMsg[1] === "1")
//                    return "yellow"
                if (statusBar.connStatusMsg[1] === "3")
                    return "cyan"
                return "blue"
           }
       }
       Rectangle {
           id: genConnection
           width: 50
           height: 50
           anchors {
               top: parent.top
               right: relConnection.left
               rightMargin: 10
           }
           color: {
               if (statusBar.connStatusMsg[0] === "255") return "black"
                if (statusBar.connStatusMsg[2] === "0")
                    return "red"
//                if (statusBar.connStatusMsg[2] === "2")
//                    return "magenta"
//                if (statusBar.connStatusMsg[2] === "1")
//                    return "yellow"
                if (statusBar.connStatusMsg[2] === "3")
                    return "cyan"
                return "blue"
           }
       }
       Rectangle {
           id: relConnection
           width: 50
           height: 50
           anchors {
               top: parent.top
               right: parent.right
           }
           color: {
               if (statusBar.connStatusMsg[0] === "255") return "black"
                if (statusBar.connStatusMsg[3] === "0")
                    return "red"
//                if (statusBar.connStatusMsg[3] === "2")
//                    return "magenta"
//                if (statusBar.connStatusMsg[3] === "1")
//                    return "yellow"
                if (statusBar.connStatusMsg[3] === "3")
                    return "cyan"
                return "blue"


           }
       }
    }
}
