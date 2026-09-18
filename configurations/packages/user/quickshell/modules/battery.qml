import QtQuick
import Quickshell.Services.UPower

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

            let batColor = theme.base05;
            if(!UPower.onBattery)
                batColor = theme.base0D;
            else if(bat.percentage * 100 <= batteryText.warningPercentage)
                batColor = theme.base08;
            batteryText.color = batColor;
            
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
