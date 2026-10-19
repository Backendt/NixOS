import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Rectangle {
    id: card

    required property var modelData
    readonly property var notif: modelData
    readonly property bool critical: notif?.urgency === NotificationUrgency.Critical
    readonly property bool hovered: cardMouseArea.containsMouse
    readonly property string iconSource: {
        if (!notif) return "";
        if (notif.image) return notif.image;
        if (notif.appIcon.startsWith("/") || notif.appIcon.startsWith("file://")) return notif.appIcon;
        return notif.appIcon ? Quickshell.iconPath(notif.appIcon, true) : "";
    }

    implicitWidth: 360
    implicitHeight: content.implicitHeight + 24
    radius: 10
    color: hovered ? theme.base03 : theme.base01
    border.width: 1
    border.color: critical ? theme.base08 : hovered ? theme.base0D : theme.base03

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    RetainableLock {
        object: card.notif
        locked: true
    }

    MouseArea {
        id: cardMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            let defaultAction = card.notif?.actions.find(a => a.identifier === "default");
            if (defaultAction) defaultAction.invoke();
            else card.notif?.dismiss();
        }
    }

    RowLayout {
        id: content
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 12

        IconImage {
            Layout.alignment: Qt.AlignTop
            implicitSize: 36
            source: card.iconSource
            visible: card.iconSource !== ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 4

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: card.notif?.appName || "Notification"
                    color: card.critical ? theme.base08 : theme.base04
                    elide: Text.ElideRight
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize - 1
                }

                Text {
                    text: {
                        let date = card.notif ? root.notifications.receivedAt[card.notif.id] : undefined;
                        return date ? Qt.formatDateTime(date, "hh:mm") : "";
                    }
                    color: theme.base04
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize - 1
                }

                Text {
                    text: "󰅖"
                    color: closeMouseArea.containsMouse ? theme.base08 : theme.base04
                    font.family: root.fontFamily
                    font.pointSize: root.fontSize

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: card.notif?.dismiss()
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: card.notif?.summary ?? ""
                color: theme.base05
                font.bold: true
                elide: Text.ElideRight
                font.family: root.fontFamily
                font.pointSize: root.fontSize
            }

            Text {
                Layout.fillWidth: true
                text: card.notif?.body ?? ""
                visible: text !== ""
                color: theme.base04
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                maximumLineCount: 4
                elide: Text.ElideRight
                font.family: root.fontFamily
                font.pointSize: root.fontSize - 1
            }

            Flow {
                Layout.fillWidth: true
                Layout.topMargin: 4
                spacing: 6
                visible: children.length > 1

                Repeater {
                    model: card.notif?.actions.filter(a => a.identifier !== "default") ?? []

                    Rectangle {
                        required property var modelData

                        implicitWidth: actionText.implicitWidth + 16
                        implicitHeight: actionText.implicitHeight + 8
                        radius: 6
                        color: actionMouseArea.containsMouse ? theme.base0D : theme.base03

                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: modelData.text
                            color: actionMouseArea.containsMouse ? theme.base00 : theme.base05
                            font.family: root.fontFamily
                            font.pointSize: root.fontSize - 1
                        }

                        MouseArea {
                            id: actionMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.invoke()
                        }
                    }
                }
            }
        }
    }
}
