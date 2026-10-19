import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: menuWindow

    readonly property var service: root.stats
    property real progress: service.menuOpen ? 1 : 0

    Behavior on progress {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    // Only anchored to the top, so the menu is centered under the clock
    anchors.top: true

    screen: service.screen
    visible: progress > 0
    implicitWidth: 340
    implicitHeight: panel.implicitHeight + 16
    exclusiveZone: 0
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-stats"
    WlrLayershell.keyboardFocus: service.menuOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    // Clicking anywhere outside the menu (or the bar) closes it
    HyprlandFocusGrab {
        windows: [menuWindow, ...root.bar.instances]
        active: menuWindow.service.menuOpen && menuWindow.visible
        onCleared: menuWindow.service.menuOpen = false
    }

    Rectangle {
        id: panel
        x: 8
        y: 8 - (implicitHeight + 8) * (1 - menuWindow.progress)
        width: parent.width - 16
        implicitHeight: content.implicitHeight + 28
        opacity: menuWindow.progress
        radius: 12
        color: theme.base00
        border.width: 1
        border.color: theme.base03

        focus: true
        Keys.onEscapePressed: menuWindow.service.menuOpen = false

        ColumnLayout {
            id: content
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 14
            }
            spacing: 14

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    id: dateText
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                    color: theme.base05
                    font.bold: true
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize + 2

                    Timer {
                        interval: 60000
                        running: menuWindow.visible
                        triggeredOnStart: true
                        repeat: true
                        onTriggered: dateText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d")
                    }
                }

                Text {
                    text: "󰔟 up " + menuWindow.service.formatUptime(menuWindow.service.uptime) + "    󰊚 " + menuWindow.service.loadAvg
                    color: theme.base04
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize - 1
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: theme.base03
            }

            Repeater {
                // Keyed by label so rows stay alive (and animate) across polls
                model: ScriptModel {
                    values: menuWindow.service.items.map(i => i.label)
                }

                StatRow {
                    required property string modelData
                    readonly property var stat: menuWindow.service.items.find(i => i.label === modelData)

                    Layout.fillWidth: true
                    icon: stat?.icon ?? ""
                    label: modelData
                    value: stat?.text ?? ""
                    ratio: stat?.ratio ?? 0
                    critical: stat?.critical ?? false
                    // Plain strings only notify on change, so buttons aren't rebuilt on every poll
                    readonly property string device: stat?.disk?.device ?? ""
                    readonly property string mountpoint: stat?.disk?.mountpoint ?? ""
                    readonly property bool external: stat?.disk?.external ?? false

                    actions: {
                        let service = menuWindow.service;
                        if (device === "") return [];
                        if (mountpoint === "")
                            return [{ text: "󰕒 Mount", trigger: () => service.mount(device) }];
                        let actions = [{ text: " Open", trigger: () => service.open(mountpoint) }];
                        if (external)
                            actions.push({ text: "󰇪", trigger: () => service.unmount(device) });
                        return actions;
                    }
                }
            }
        }
    }
}
