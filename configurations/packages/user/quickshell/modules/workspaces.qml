import QtQuick
import Quickshell
import Quickshell.Hyprland

Repeater {

    property int workspaceAmount: 10
    model: workspaceAmount
    
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
