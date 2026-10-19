import QtQuick

import "bar"
import "notifications"
import "stats"

QtObject {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 10

    readonly property var theme: Theme {}

    readonly property var notifications: NotificationService {}
    readonly property var stats: StatsService {}

    readonly property var bar: Bar {}
    readonly property var notificationPopups: NotificationPopups {}
    readonly property var notificationCenter: NotificationCenter {}
    readonly property var statsMenu: StatsMenu {}
}
