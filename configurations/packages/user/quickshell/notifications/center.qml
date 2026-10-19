import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: centerWindow

    readonly property var service: root.notifications
    property real progress: service.centerOpen ? 1 : 0

    Behavior on progress {
        NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
    }

    anchors {
        top: true
        right: true
        bottom: true
    }

    screen: service.screen
    visible: progress > 0
    implicitWidth: 400
    exclusiveZone: 0
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notification-center"
    WlrLayershell.keyboardFocus: service.centerOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    HyprlandFocusGrab {
        windows: [centerWindow, ...root.bar.instances]
        active: centerWindow.service.centerOpen && centerWindow.visible
        onCleared: centerWindow.service.centerOpen = false
    }

    Rectangle {
        id: panel
        width: parent.width - 16
        height: parent.height - 16
        y: 8
        x: 8 + parent.width * (1 - centerWindow.progress)
        opacity: centerWindow.progress
        radius: 12
        color: theme.base00
        border.width: 1
        border.color: theme.base03

        focus: true
        Keys.onEscapePressed: centerWindow.service.centerOpen = false

        ColumnLayout {
            anchors {
                fill: parent
                margins: 14
            }
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Notifications"
                    color: theme.base05
                    font.bold: true
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize + 2
                }

                Rectangle {
                    implicitWidth: Math.max(implicitHeight, countText.implicitWidth + 10)
                    implicitHeight: countText.implicitHeight + 4
                    radius: height / 2
                    color: theme.base0D
                    visible: centerWindow.service.count > 0

                    Text {
                        id: countText
                        anchors.centerIn: parent
                        text: centerWindow.service.count
                        color: theme.base00
                        font.bold: true
                        font.family: root.fontFamily
                        font.pointSize: root.fontSize - 1
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "󰎟 Clear all"
                    visible: centerWindow.service.count > 0
                    color: clearMouseArea.containsMouse ? theme.base08 : theme.base04
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize

                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        id: clearMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: centerWindow.service.clearAll()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: theme.base03
            }

            ListView {
                id: centerList
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                model: ScriptModel {
                    values: centerWindow.service.list.slice().reverse()
                }

                delegate: NotificationCard {
                    width: ListView.view.width
                }

                add: Transition {
                    NumberAnimation { property: "x"; from: centerList.width; to: 0; duration: 350; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
                }

                remove: Transition {
                    NumberAnimation { property: "x"; to: centerList.width; duration: 250; easing.type: Easing.InCubic }
                    NumberAnimation { property: "opacity"; to: 0; duration: 250 }
                }

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 300; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "opacity"; to: 1; duration: 150 }
                }

                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: "󰂛\nNo notifications"
                    color: theme.base04
                    opacity: centerWindow.service.count === 0 ? 1 : 0
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize + 2

                    Behavior on opacity { NumberAnimation { duration: 250 } }
                }
            }
        }
    }
}
