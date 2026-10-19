import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: statRow

    property string icon
    property string label
    property string value
    property real ratio: 0
    property bool critical: false

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
