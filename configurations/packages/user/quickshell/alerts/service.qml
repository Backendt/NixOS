import QtQuick
import Quickshell
import Quickshell.Services.UPower

// Sends a critical notification when a resource becomes critical, once per occurrence
QtObject {
    id: service

    readonly property int batteryCritical: 15 // In percent

    readonly property var stats: root.stats
    readonly property real memRatio: stats.memTotal > 0 ? stats.memUsed / stats.memTotal : 0
    readonly property bool memLow: memRatio >= stats.memCritical

    readonly property var bat: UPower.displayDevice
    readonly property int batteryPercent: Math.round((bat?.percentage ?? 0) * 100)
    readonly property bool batteryLow: bat?.ready === true && UPower.onBattery && batteryPercent <= batteryCritical

    onMemLowChanged: {
        if (memLow)
            notify("dialog-warning", "Memory almost full",
                   Math.round(memRatio * 100) + "% used (" + stats.formatSize(stats.memUsed) + " / " + stats.formatSize(stats.memTotal) + ")");
    }

    onBatteryLowChanged: {
        if (batteryLow)
            notify("battery-caution", "Battery low", batteryPercent + "% remaining, plug in the charger");
    }

    function notify(icon, summary, body) {
        Quickshell.execDetached(["notify-send", "-u", "critical", "-a", "System", "-i", icon, summary, body]);
    }
}
