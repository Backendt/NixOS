import QtQuick
import Quickshell

Row {
    id: clockModule

    readonly property var service: root.stats

    spacing: 8

    Text {
        id: clock
        color: {
            if (clockModule.service.menuOpen) return theme.base0D;
            if (clockMouseArea.containsMouse) return theme.base0E;
            return theme.base05;
        }
        text: "Time is a social construct"
        font.pointSize: root.fontSize
        font.family: root.fontFamily

        Behavior on color { ColorAnimation { duration: 150 } }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "MMM dd, hh:mm")
        }

        MouseArea {
            id: clockMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: clockModule.service.toggleMenu(QsWindow.window.screen)
        }
    }

    // Icons of the stats currently in a critical state
    Repeater {
        model: ScriptModel {
            values: clockModule.service.criticalItems.map(i => i.icon)
        }

        Text {
            id: criticalIcon
            required property string modelData

            text: modelData
            color: theme.base08
            font.pointSize: root.fontSize
            font.family: root.fontFamily

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 1; to: 0.35; duration: 900; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.35; to: 1; duration: 900; easing.type: Easing.InOutSine }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: clockModule.service.toggleMenu(QsWindow.window.screen)
            }
        }
    }
}
