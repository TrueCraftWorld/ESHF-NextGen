import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Extras 1.4
import QtMultimedia 5.15
import DarkSide 1.0
import QtQuick.CuteKeyboard 1.0

Item {
    id: mainPage
    anchors.fill: parent

    property var messagePopUp: null


    function createMessagePopUp(messageType, messageContent) {
        if (messagePopUp === null) {
            var component = Qt.createComponent("MessagePopUp.qml")
            if (component.status === Component.Ready){
                uart.writeData("S" + "0" + "  \n")
                messagePopUp = component.createObject( mainPage, {"x":0, "y":0, "messageType": messageType, "messageContent": messageContent})
                if (messagePopUp) {
                    messagePopUp.destroyMe.connect( deleteMessagePopUp )
                }
            }
        }
    }
    function deleteMessagePopUp() {
        if (messagePopUp !== null) {
            uart.writeData("S" + (activeReady.checked ? "1" : "0") + "  \n")
            messagePopUp.destroy()
            messagePopUp = null
        }
    }

    function checkActivation(messageContent) {
        var string = messageContent.toString()

        if (string.charAt(0) === 'A') {
            var nums = string.match(/\d+/g)
            var out = nums[0]*1;
            var socket = Math.floor((out + 1)/2)
            var activeSide = out%2

            if (doublePed.bindedSocket != null) {
                if (doublePed.bindedSocket.socketType == (socket) ) {
                    if( activeSide === 1) {
                        if (doublePed.bindedSocket.cutModeIndex > 0) {
                            doublePed.bindedSocket.socketStatus = SocketControl.S_ACTIVE_CUT
//                            sound.source = "file:///usr/share/qtpr/CUT_SOUND.mp3";
//                            sound.play();
                        }
                    } else if (activeSide === 0) {
                        if (doublePed.bindedSocket.coagModeIndex > 0) {
                            doublePed.bindedSocket.socketStatus = SocketControl.S_ACTIVE_COAG
//                            if (doublePed.bindedSocket.socketType > SocketControl.BIPOLAR_2) {
//                                sound.source = "file:///usr/share/qtpr/MONO_COAG_SOUND.mp3"
//                            } else {
//                                sound.source = "file:///usr/share/qtpr/BI_COAG_SOUND.mp3"
//                            }
//                            sound.play();
                        }
                    }
                }
            }
            if (singlePed.bindedSocket != null) {
                if (singlePed.bindedSocket.socketType == (socket) ) {
                    if (activeSide === 0) {
                        if (singlePed.bindedSocket.coagModeIndex > 0) {
                            singlePed.bindedSocket.socketStatus = SocketControl.S_ACTIVE_COAG
//                            if (singlePed.bindedSocket.socketType > SocketControl.BIPOLAR_2) {
//                                sound.source = "file:///usr/share/qtpr/MONO_COAG_SOUND.mp3"
//                            } else {
//                                sound.source = "file:///usr/share/qtpr/BI_COAG_SOUND.mp3"
//                            }
//                            sound.play();
                        }
                    }
                }
            }
        }
        if (string === "COM_4\r\n") {
             if (bi_1.socketStatus > SocketControl.S_ENABLED) bi_1.socketStatus = SocketControl.S_ENABLED
             if (bi_2.socketStatus > SocketControl.S_ENABLED) bi_2.socketStatus = SocketControl.S_ENABLED
             if (mono_1.socketStatus > SocketControl.S_ENABLED) mono_1.socketStatus = SocketControl.S_ENABLED
             if (mono_2.socketStatus > SocketControl.S_ENABLED) mono_2.socketStatus = SocketControl.S_ENABLED
//             sound.stop();
        }

    }


    Connections {
        target: uart
        function onResponseChanged() {
            statusBarTop.update()
            checkActivation(uart.response)
        }
    }

    Shortcut {
        id:backShortcut
        sequences: ["Esc"]

        onActivated: {
            root.close();
        }
    }

//    KeyBoardIntercept {
//        id: keyCatch
//    }

    Rectangle {
        anchors.fill: parent
        focus: true
        opacity: 0
        Keys.priority: Keys.AfterItem
        Keys.onPressed: (event)=> {
//            event.key = 0;
            event.accepted = true;
            keyCatch.handleKeyPressed(event);
        }
    }

    StatusBar {
        id: statusBarTop
    }

    Rectangle {
        id: leftPillar
        width: statusBarTop.height
        color: "#585858"
        anchors {
            left: parent.left
            bottom: parent.bottom
            top: mainPageLoader.top
            topMargin: 5
        }
        Button {
            id: shutdown
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 50
            height: 50
            Rectangle {
                width: parent.width
                height: parent.height
            }

            onClicked: {
                root.close();
            }
        }
        Button {
            id: cutActiv
            anchors.left: parent.left
            anchors.bottom: shutdown.top
            width: 50
            height: 50
            Rectangle {
                color: "yellow"
                width: parent.width
                height: parent.height
            }
            onPressed: {
                if (activeReady.checked) {
                    if (doublePed.bindedSocket != null)
                        if (doublePed.bindedSocket.cutModeIndex > 0) {
                            doublePed.bindedSocket.socketStatus = SocketControl.S_ACTIVE_CUT
                            sound.source = "file:///usr/share/qtpr/CUT_SOUND.wav"
                            sound.play()
                        }
                        else createMessagePopUp(1, "NO MODE")
                    else createMessagePopUp(1, "EMPTY PEDAL")
                } else createMessagePopUp(0, "NOT PERMITTED")
            }
            onReleased: {
                if (doublePed.bindedSocket != null)
                    doublePed.bindedSocket.socketStatus = SocketControl.S_ENABLED
                    sound.stop()

            }
        }
        Button {
            id: coagActiv
            anchors.left: parent.left
            anchors.bottom: cutActiv.top

            width: 50
            height: 50
            Rectangle {
                color: "blue"
                width: parent.width
                height: parent.height
            }
            onPressed: {
                 if (activeReady.checked) {
                     if (doublePed.bindedSocket != null)
                         if (doublePed.bindedSocket.coagModeIndex > 0) {
                            doublePed.bindedSocket.socketStatus = SocketControl.S_ACTIVE_COAG
                             if (doublePed.bindedSocket.socketType > SocketControl.BIPOLAR_2) {
                                 sound.source = "file:///usr/share/qtpr/MONO_COAG_SOUND.wav"
                             } else {
                                 sound.source = "file:///usr/share/qtpr/BI_COAG_SOUND.wav"
                             }
                             sound.play()
                         }
                         else createMessagePopUp(1, "NO MODE")
                     else createMessagePopUp(1, "EMPTY PEDAL")
                 } else createMessagePopUp(0, "NOT PERMITTED")
            }
            onReleased: {
                if (doublePed.bindedSocket != null) {
                    doublePed.bindedSocket.socketStatus = SocketControl.S_ENABLED
                    sound.stop()
                }
            }
        }
        Button {
            id: coagActivSingle
            anchors.left: parent.left
            anchors.bottom: coagActiv.top
            anchors.bottomMargin: 20

            width: 50
            height: 50
            Rectangle {
                color: "blue"
                width: parent.width
                height: parent.height
            }
            onPressed: {
                if (activeReady.checked) {
                    if (singlePed.bindedSocket != null)
                        if (singlePed.bindedSocket.coagModeIndex > 0) {
                            singlePed.bindedSocket.socketStatus = SocketControl.S_ACTIVE_COAG
                            if (singlePed.bindedSocket.socketType > SocketControl.BIPOLAR_2) {
                                sound.source = "file:///usr/share/qtpr/MONO_COAG_SOUND.wav"
                            } else {
                                sound.source = "file:///usr/share/qtpr/BI_COAG_SOUND.wav"
                            }
                            sound.play()
                        }
                        else createMessagePopUp(1, "NO MODE")
                    else createMessagePopUp(1, "EMPTY PEDAL")
                } else createMessagePopUp(0, "NOT PERMITTED")
            }
            onReleased: {

                if (singlePed.bindedSocket != null) {

                    singlePed.bindedSocket.socketStatus = SocketControl.S_ENABLED
//                    sound.stop()
                }
            }
        }
        Button {
            id: checkMessage
            anchors.left: parent.left
            anchors.bottom: coagActivSingle.top
            anchors.bottomMargin: 20

            width: 50
            height: 50
            Rectangle {
                color: "red"
                width: parent.width
                height: parent.height
            }
            onClicked: {
                if (!(video1.playbackState == MediaPlayer.PlayingState || u.visible == true ||
                      video2.playbackState == MediaPlayer.PlayingState || video2.visible == true ||
                      video3.playbackState == MediaPlayer.PlayingState || video3.visible == true ||
                      video4.playbackState == MediaPlayer.PlayingState || video4.visible == true)){
                    createMessagePopUp(2, "HELLO!")
                }
                if (video1.playbackState == MediaPlayer.PlayingState || video1.visible == true)
                {
                    video1.pause()
                    video1.visible = false
                }
                if (video2.playbackState == MediaPlayer.PlayingState || video2.visible == true)
                {
                    video2.pause()
                    video2.visible = false
                }
                if (video4.playbackState == MediaPlayer.PlayingState || video4.visible == true)
                {
                    video4.pause()
                    video4.visible = false
                }
                if (video3.playbackState == MediaPlayer.PlayingState || video3.visible == true)
                {
                    video3.pause()
                    video3.visible = false
                }

            }
        }
        Button {
            id: videoButton
            anchors.left: parent.left
            anchors.bottom: checkMessage.top
            anchors.bottomMargin: 20

            width: 50
            height: 50
            Rectangle {
                color: "magenta"
                width: parent.width
                height: parent.height
            }
            onClicked: {
                video1.source = "file:///home/kikorik/test1.mp4"
                video1.visible = true
                video1.volume = 1.0
                video1.play()
                video3.source = "file:///home/kikorik/test2.mp4"
                video3.visible = true
                video3.volume = 1.0
                video3.play()
            }
        }
        Button {
            id: videoButton2
            anchors.left: parent.left
            anchors.bottom: videoButton.top
            anchors.bottomMargin: 20

            width: 50
            height: 50
            Rectangle {
                color: "cyan"
                width: parent.width
                height: parent.height
            }
            onClicked: {
                video2.source = "file:///home/kikorik/test0.mp4"
                video2.visible = true
                video2.volume = 1.0
                video2.play()
                video4.source = "file:///home/kikorik/test2.mkv"
                video4.visible = true
                video4.volume = 1.0
                video4.play()
            }
        }
        Button {
            id: loaderButton
            anchors.left: parent.left
            anchors.bottom: videoButton2.top
            anchors.bottomMargin: 20

            width: 50
            height: 50
            Rectangle {
                color: "green"
                width: parent.width
                height: parent.height
            }
            onClicked: {
                mainPageLoader.active = true
//                mainPageLoader.source = "qrc:/UI/WorkScreen/WorkScreenStack.qml"
                visible = false
                console.log('tuta')
            }
        }
        ToggleButton {
            id: activeReady
            anchors.top: parent.top
            width: parent.width
            height: width
            onCheckedChanged: {
                uart.writeData("S" + (activeReady.checked ? "1" : "0") + "  \n")
            }
        }
    }

    Loader {
        id: mainPageLoader
        asynchronous: true
        active: false
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: leftPillar.right
            top: statusBarTop.bottom
            margins: 10
        }
//        active: false
        source: "qrc:/UI/WorkScreen/WorkScreenStack.qml"
    }

    Video {
        id: video1
        width : 550
        height : 330
        visible: false
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 70
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video1.playbackState == MediaPlayer.PlayingState ? video1.pause() : video1.play()
            }
        }
        onStopped: {
                            video1.visible = false
        }

//        focus: true
//        Keys.onSpacePressed: video1.playbackState == MediaPlayer.PlayingState ? video1.pause() : video1.play()
//        Keys.onLeftPressed: video1.seek(video1.position - 5000)
//        Keys.onRightPressed: video1.seek(video1.position + 5000)
    }
    Video {
        id: video2
        width : 550
        height : 330
        visible: false
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 70
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video2.playbackState == MediaPlayer.PlayingState ? video2.pause() : video2.play()
            }
        }
        onStopped: {
                            video2.visible = false
        }

//        focus: true
//        Keys.onSpacePressed: video2.playbackState == MediaPlayer.PlayingState ? video2.pause() : video2.play()
//        Keys.onLeftPressed: video2.seek(video2.position - 5000)
//        Keys.onRightPressed: video2.seek(video2.position + 5000)
    }

    Video {
        id: video3
        width : 550
        height : 330
        visible: false
        anchors {
            left: parent.left
            top: parent.top
            margins: 70
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video3.playbackState == MediaPlayer.PlayingState ? video3.pause() : video3.play()
            }
        }
        onStopped: {
                            video3.visible = false
        }

//        focus: true
//        Keys.onSpacePressed: video3.playbackState == MediaPlayer.PlayingState ? video3.pause() : video3.play()
//        Keys.onLeftPressed: video3.seek(video3.position - 5000)
//        Keys.onRightPressed: video3.seek(video3.position + 5000)
    }
    Video {
        id: video4
        width : 550
        height : 330
        visible: false
        anchors {
            right: parent.right
            top: parent.top
            margins: 70
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video4.playbackState == MediaPlayer.PlayingState ? video4.pause() : video4.play()
            }
        }
        onStopped: {
                            video4.visible = false
        }

//        focus: true
//        Keys.onSpacePressed: video2.playbackState == MediaPlayer.PlayingState ? video2.pause() : video2.play()
//        Keys.onLeftPressed: video2.seek(video2.position - 5000)
//        Keys.onRightPressed: video2.seek(video2.position + 5000)
    }

    Audio {
        id: sound
        loops: Audio.Infinite
    }

    InputPanel {
        id: inputPanel

        z: 99
        y: mainPage.height

        anchors.left: parent.left
        anchors.right: parent.right

        states: State {
            name: "visible"
            when: Qt.inputMethod.visible
            PropertyChanges {
                target: inputPanel
                y: mainPage.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }


}
