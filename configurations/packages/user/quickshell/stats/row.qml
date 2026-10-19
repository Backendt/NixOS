import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: statRow

    property string icon
    property string label
    property string value
    property real ratio: 0
    property bool critical: false
    property var actions: [] // Buttons shown on the right: [{ text, trigger }]

    readonly property color accent: critical ? theme.base08 : theme.base0D

    spacing: 6

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Text {
            Layout.preferredWidth: 18
            text: statRow.icon
            color: statRow.accent
            font.family: root.fontFamily
            font.pointSize: root.fontSize + 1

            Behavior on color { ColorAnimation { duration: 250 } }
        }

        Text {
            Layout.fillWidth: true
            text: statRow.label
            color: theme.base05
            elide: Text.ElideRight
            font.family: root.fontFamily
            font.pointSize: root.fontSize
        }

        Text {
            text: statRow.value
            color: statRow.critical ? theme.base08 : theme.base04
            font.bold: statRow.critical
            font.family: root.fontFamily
            font.pointSize: root.fontSize
        }

        Repeater {
            model: statRow.actions

            Rectangle {
                required property var modelData

                implicitWidth: actionLabel.implicitWidth + 14
                implicitHeight: actionLabel.implicitHeight + 6
                radius: 6
                color: actionMouseArea.containsMouse ? theme.base0D : theme.base03

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    id: actionLabel
                    anchors.centerIn: parent
                    text: modelData.text
                    color: actionMouseArea.containsMouse ? theme.base00 : theme.base05
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize - 1
                }

                MouseArea {
                    id: actionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.trigger()
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 6
        radius: 3
        color: theme.base03

        Rectangle {
            width: parent.width * Math.max(0, Math.min(statRow.ratio, 1))
            height: parent.height
            radius: parent.radius
            color: statRow.accent

            Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 250 } }
        }
    }
}
