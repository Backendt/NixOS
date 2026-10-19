import QtQuick
import Quickshell

import "audio"
import "bar"
import "notifications"
import "stats"

QtObject {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 10

    readonly property var theme: Theme {}

    readonly property var audio: AudioService {}
    readonly property var notifications: NotificationService {}
    readonly property var stats: StatsService {}

    // External monitors when any are plugged in, the laptop screen otherwise
    readonly property var barScreens: {
        let external = Quickshell.screens.filter(s => !/^(eDP|LVDS|DSI)/.test(s.name));
        return external.length > 0 ? external : Quickshell.screens;
    }

    readonly property var bar: Variants {
        model: root.barScreens
        Bar {}
    }
    readonly property var notificationPopups: NotificationPopups {}
    readonly property var notificationCenter: NotificationCenter {}
    readonly property var statsMenu: StatsMenu {}
}
