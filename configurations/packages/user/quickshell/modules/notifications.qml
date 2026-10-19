import QtQuick

Text {
    id: notificationsText

    readonly property var service: root.notifications

    font.pointSize: root.fontSize
    font.family: root.fontFamily
    text: service.count > 0 ? "󰂚 " + service.count : "󰂜"
    color: {
        if (service.centerOpen) return theme.base0D;
        if (notificationsMouseArea.containsMouse) return theme.base0E;
        return theme.base05;
    }

    Behavior on color { ColorAnimation { duration: 150 } }

    onTextChanged: if (service.count > 0) bump.restart()

    SequentialAnimation {
        id: bump
        NumberAnimation { target: notificationsText; property: "scale"; to: 1.3; duration: 120; easing.type: Easing.OutQuad }
        NumberAnimation { target: notificationsText; property: "scale"; to: 1.0; duration: 250; easing.type: Easing.OutBack; easing.overshoot: 2.5 }
    }

    MouseArea {
        id: notificationsMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: notificationsText.service.toggleCenter()
    }
}
