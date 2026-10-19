import QtQuick

import "../audio"

Text {
    id: audioModule

    readonly property var service: root.audio

    font.pointSize: root.fontSize
    font.family: root.fontFamily

    text: {
        if (!service.ready) return service.icon;
        return service.icon + " " + (service.muted ? 0 : Math.round(service.volume * 100)) + "%";
    }
    color: {
        if (!service.ready || service.muted) return theme.base08;
        if (volumePopup.open) return theme.base0D;
        if (audioMouseArea.containsMouse) return theme.base0E;
        return theme.base05;
    }

    Behavior on color { ColorAnimation { duration: 150 } }

    MouseArea {
        id: audioMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: volumePopup.open = !volumePopup.open
        onWheel: wheel => audioModule.service.setVolume(audioModule.service.volume + Math.sign(wheel.angleDelta.y) * audioModule.service.step)
    }

    VolumePopup {
        id: volumePopup
        anchorItem: audioModule
    }
}
