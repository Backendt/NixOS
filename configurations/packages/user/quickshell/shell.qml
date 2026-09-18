import QtQuick

import "bar"

QtObject {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 10

    readonly property var theme: Theme {}

    readonly property var bar: Bar {}
}
