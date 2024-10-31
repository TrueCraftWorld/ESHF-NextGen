import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12
import DarkSide 1.0

Item {
    anchors.fill: parent
    Socket {
        id: bi_1_visual
        socketIndex: bi_1
        anchors{
            right: parent.horizontalCenter
            bottom: parent.verticalCenter
            margins: 5
        }
    }
    Socket {
        id: bi_2_visual
        socketIndex: bi_2
        anchors{
            left: parent.horizontalCenter
            bottom: parent.verticalCenter
            margins: 5
        }
    }
    Socket {
        id: mono_1_visual
        socketIndex: mono_1
        anchors{
            right: parent.horizontalCenter
            top: parent.verticalCenter
            margins: 5
        }
    }
    Socket {
        id: mono_2_visual
        socketIndex: mono_2
        anchors{
            left: parent.horizontalCenter
            top: parent.verticalCenter
            margins: 5
        }
    }
}
