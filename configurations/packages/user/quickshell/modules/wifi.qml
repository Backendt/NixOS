import QtQuick
import Quickshell.Io

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
