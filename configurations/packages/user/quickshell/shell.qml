import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Io

PanelWindow {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 10

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30

    Theme { id: theme }
    color: theme.base00
    PwObjectTracker {
        id: pw
        objects: [ Pipewire.defaultAudioSink ]
    }

    Text {
        id: clock
        anchors.centerIn: parent
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

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }

        Row { // LEFT MODULES
            Layout.alignment: Qt.AlignLeft
            spacing: 4
            
            Repeater {
                model: 10
                
                Rectangle {
                    width: 24
                    height: 24
                    radius: 6

                    readonly property int workspaceId: index + 1
                    readonly property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId) 
                    readonly property bool isFocused: Hyprland.focusedWorkspace?.id === workspaceId
                    readonly property bool isOccupied: workspace !== undefined

                    color: {
                        if(isFocused) return theme.base0D;
                        if(workspace && workspace.urgent) return theme.base08;
                        if(workspaceMouseArea.containsMouse) return theme.base03;
                        return theme.base00;
                    }
                    
                    scale: isFocused ? 1.2 : 1.0
                    Text {
                        anchors.centerIn: parent
                        text: workspaceId
                        color: isFocused ? theme.base00 : isOccupied ? theme.base05 : theme.base04
                        font.bold: isOccupied
                        font.family: root.fontFamily
                        font.pointSize: root.fontSize
                    }
                    
                    MouseArea {
                        id: workspaceMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + workspaceId)

                        hoverEnabled: true
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutBack
                            easing.overshoot: 2.5
                        }
                    }
                }
            }
        }

        Item {Layout.fillWidth: true} // SPACER

        RowLayout { // RIGHT MODULES
            Layout.alignment: Qt.AlignRight
            spacing: 16

            Row {
                spacing: 8
                
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
            }

            Text {
                id: wifiText
                color: theme.base05
                text: "  Loading..."
                font.pointSize: root.fontSize
                font.family: root.fontFamily

                Process {
                    id: wifiProcess
                    command: ["iwgetid", "-r"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: {
                            let ssid = text.trim();
                            wifiText.text = ssid ? " " : "󰖪 ";
                            wifiText.color = ssid ? theme.base05 : theme.base08;
                        }
                    }
                }
                Timer {
                    interval: 5000
                    running: true
                    repeat: true
                    onTriggered: wifiProcess.running = true
                }
            }

            Text {
                font.pointSize: root.fontSize
                font.family: root.fontFamily
                
                color: {
                    let sink = pw.objects[0];
                    if(sink && sink.audio && sink.audio.muted)
                        return theme.base08
                    return theme.base05
                }
                text: {
                    let sink = pw.objects[0];
                    if (sink && sink.audio) {
                        let vol = Math.round(sink.audio.volume * 100)
                        if(sink.audio.muted) {
                            return "󰝟 0%";
                        }
                        return "󰕾 " + vol + "%";
                    }
                    return "󰖁 "
                }
            }

            
            Text {
                id: batteryText
                font.pointSize: root.fontSize
                font.family: root.fontFamily
                color: theme.base05
                text: "󰂑 ?%"
                readonly property int warningPercentage: 15
                
                Timer {
                    interval: 5000
                    running: true
                    repeat: true
                    onTriggered: {
                        let bat = UPower.displayDevice;
                        if(!bat.ready)
                            return;

                        let batColor = theme.base08;
                        if(!UPower.onBattery)
                            batColor = theme.base0D;
                        else if(bat.percentage <= batteryText.warningPercentage)
                            batColor = theme.base05;
                        batteryText.color = batColor
                        
                        let percent = Math.round(bat.percentage * 100);
                        
                        let logo = "󰁹 ";
                        if (!UPower.onBattery) logo = "󰂄 ";
                        else if (percent <= 10) logo = "󰂃 ";
                        else if (percent <= 30) logo = "󰁼 ";
                        else if (percent <= 50) logo = "󰁾 ";
                        else if (percent <= 80) logo = "󰂀 ";
                        batteryText.text = logo + percent + "%";
                    }
                }
            } 

            
        }
    }
}
