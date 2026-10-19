import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: popup

    required property Item anchorItem
    readonly property var service: root.audio

    property bool open: false
    property real progress: open ? 1 : 0

    Behavior on progress {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    anchor {
        item: popup.anchorItem
        edges: Edges.Bottom
        gravity: Edges.Bottom
        margins.top: 8
    }

    visible: progress > 0
    implicitWidth: 260
    implicitHeight: panel.implicitHeight
    color: "transparent"

    // Clicking anywhere outside the popup (or the bar) closes it
    HyprlandFocusGrab {
        windows: [popup, ...root.bar.instances]
        active: popup.open && popup.visible
        onCleared: popup.open = false
    }

    Rectangle {
        id: panel
        width: parent.width
        implicitHeight: content.implicitHeight + 20
        y: -8 * (1 - popup.progress)
        opacity: popup.progress
        radius: 10
        color: theme.base00
        border.width: 1
        border.color: theme.base03

        RowLayout {
            id: content
            anchors {
                fill: parent
                margins: 10
            }
            spacing: 10

            Text {
                text: popup.service.icon
                color: popup.service.muted ? theme.base08 : muteMouseArea.containsMouse ? theme.base0E : theme.base05
                font.family: root.fontFamily
                font.pointSize: root.fontSize + 3

                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    id: muteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: popup.service.toggleMute()
                }
            }

            VolumeSlider {
                Layout.fillWidth: true
                value: popup.service.volume
                muted: popup.service.muted
                onMoved: popup.service.setVolume(value)
            }

            Text {
                Layout.preferredWidth: 36
                horizontalAlignment: Text.AlignRight
                text: Math.round(popup.service.volume * 100) + "%"
                color: popup.service.muted ? theme.base04 : theme.base05
                font.family: root.fontFamily
                font.pointSize: root.fontSize
            }
        }
    }
}
