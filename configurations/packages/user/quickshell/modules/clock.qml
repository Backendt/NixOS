import QtQuick

Text {
    id: clock
    color: theme.base05
    text: "Time is a social construct"
    font.pointSize: root.fontSize
    font.family: root.fontFamily
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "MMM dd, hh:mm")
    }
}
