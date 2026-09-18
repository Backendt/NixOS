import QtQuick
import QtQuick.Layouts

import "../modules"

Row {
    anchors.right: parent.right
    spacing: 16

    Tray { }
    Wifi { }
    Audio { }
    Battery { }
    Notifications { }
}
