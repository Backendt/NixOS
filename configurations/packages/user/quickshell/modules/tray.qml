import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Repeater {
    model: SystemTray.items

    Item {
        width: 20
        height: 20

        Image {
            anchors.fill: parent
            source: modelData.icon
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(20, 20)
        }

        QsMenuOpener {
            id: trayMenu
            menu: modelData.menu
        }
    }
}
