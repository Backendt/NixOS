import QtQuick
import Quickshell

PanelWindow {
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30
    color: theme.base00

    Item {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }

        LeftModules {
            anchors.verticalCenter: parent.verticalCenter
        }

        CenterModules {
            anchors.verticalCenter: parent.verticalCenter
        }

        RightModules {
            anchors.verticalCenter: parent.verticalCenter
        }
    }

}
