import QtQuick
import Quickshell.Services.UPower

Text {
    id: batteryText

    readonly property var bat: UPower.displayDevice
    readonly property int percent: Math.round((bat?.percentage ?? 0) * 100)

    font.pointSize: root.fontSize
    font.family: root.fontFamily

    color: {
        if (!bat?.ready) return theme.base05;
        if (!UPower.onBattery) return theme.base0D;
        if (percent <= root.alerts.batteryCritical) return theme.base08;
        return theme.base05;
    }
    text: {
        if (!bat?.ready) return "󰂑 ?%";

        let logo = "󰁹 ";
        if (!UPower.onBattery) logo = "󰂄 ";
        else if (percent <= 10) logo = "󰂃 ";
        else if (percent <= 30) logo = "󰁼 ";
        else if (percent <= 50) logo = "󰁾 ";
        else if (percent <= 80) logo = "󰂀 ";
        return logo + percent + "%";
    }
}
