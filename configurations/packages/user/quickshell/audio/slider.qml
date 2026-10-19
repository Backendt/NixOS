import QtQuick
import QtQuick.Controls

Slider {
    id: slider

    property bool muted: false
    readonly property color accent: muted ? theme.base04 : theme.base0D

    from: 0
    to: 1
    wheelEnabled: true
    stepSize: 0.01
    implicitHeight: 20

    background: Rectangle {
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        width: slider.availableWidth
        height: 6
        radius: 3
        color: theme.base03

        Rectangle {
            width: slider.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: slider.accent

            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        width: 14
        height: 14
        radius: 7
        color: slider.pressed || slider.hovered ? theme.base05 : slider.accent
        scale: slider.pressed ? 1.2 : 1.0

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
    }
}
