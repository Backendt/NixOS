import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: popupWindow

    readonly property var service: root.notifications

    anchors {
        top: true
        right: true
    }
    margins {
        top: 8
        right: 8
    }

    screen: root.barScreens[0]
    implicitWidth: 360
    implicitHeight: screen.height * 0.8
    exclusiveZone: 0
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications"

    mask: Region { item: inputArea }

    Item {
        id: inputArea
        width: parent.width
        height: Math.min(popupList.contentHeight, parent.height)
    }

    ListView {
        id: popupList
        anchors.fill: parent
        spacing: 8
        interactive: false

        model: ScriptModel {
            values: popupWindow.service.popups
        }

        delegate: NotificationCard {
            id: popup
            width: ListView.view.width

            Timer {
                interval: popupWindow.service.timeoutFor(popup.notif)
                running: interval > 0 && !popup.hovered
                onTriggered: popupWindow.service.removePopup(popup.notif)
            }
        }

        add: Transition {
            NumberAnimation { property: "x"; from: popupWindow.width; to: 0; duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
        }

        remove: Transition {
            NumberAnimation { property: "x"; to: popupWindow.width; duration: 250; easing.type: Easing.InCubic }
            NumberAnimation { property: "opacity"; to: 0; duration: 250 }
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 300; easing.type: Easing.OutCubic }
            NumberAnimation { property: "opacity"; to: 1; duration: 150 }
        }
    }
}
