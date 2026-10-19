import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: service

    readonly property int pollInterval: 2000 // In milliseconds
    readonly property int diskPollInterval: 30000

    // Usage ratios (0 to 1) above which a stat is considered critical
    readonly property real cpuCritical: 0.9
    readonly property real memCritical: 0.9
    readonly property real swapCritical: 0.8
    readonly property real diskCritical: 0.9
    readonly property real tempCritical: 85 // In °C

    property bool menuOpen: false

    property real cpuUsage: 0
    property real cpuTemp: -1
    property real memTotal: 0 // In kB, like /proc/meminfo
    property real memUsed: 0
    property real swapTotal: 0
    property real swapUsed: 0
    property var disks: [] // [{ mount, total, used }] in kB
    property string loadAvg: ""
    property real uptime: 0 // In seconds

    property var lastCpu: null

    // Everything displayed by the menu and the bar, critical or not
    readonly property var items: {
        let list = [{
            icon: "", label: "CPU", ratio: cpuUsage,
            text: Math.round(cpuUsage * 100) + "%",
            critical: cpuUsage >= cpuCritical
        }];
        if (cpuTemp >= 0) list.push({
            icon: "", label: "Temperature", ratio: Math.min(cpuTemp / 100, 1),
            text: Math.round(cpuTemp) + "°C",
            critical: cpuTemp >= tempCritical
        });
        list.push(usage("", "Memory", memUsed, memTotal, memCritical));
        if (swapTotal > 0)
            list.push(usage("󰯍", "Swap", swapUsed, swapTotal, swapCritical));
        for (let disk of disks)
            list.push(usage("󰋊", "Disk " + disk.mount, disk.used, disk.total, diskCritical));
        return list;
    }
    readonly property var criticalItems: items.filter(i => i.critical)

    function usage(icon, label, used, total, critical) {
        let ratio = total > 0 ? used / total : 0;
        return {
            icon: icon, label: label, ratio: ratio,
            text: formatSize(used) + " / " + formatSize(total),
            critical: ratio >= critical
        };
    }

    function formatSize(kb) {
        let gb = kb / 1024 / 1024;
        return gb >= 100 ? Math.round(gb) + "G" : gb.toFixed(1) + "G";
    }

    function formatUptime(seconds) {
        let days = Math.floor(seconds / 86400);
        let hours = Math.floor(seconds % 86400 / 3600);
        let minutes = Math.floor(seconds % 3600 / 60);
        return (days > 0 ? days + "d " : "") + (days > 0 || hours > 0 ? hours + "h " : "") + minutes + "m";
    }

    readonly property FileView statFile: FileView {
        path: "/proc/stat"
        onLoaded: {
            let fields = text().split("\n")[0].trim().split(/\s+/).slice(1, 9).map(Number);
            let idle = fields[3] + fields[4];
            let total = fields.reduce((a, b) => a + b, 0);
            if (service.lastCpu && total > service.lastCpu.total)
                service.cpuUsage = 1 - (idle - service.lastCpu.idle) / (total - service.lastCpu.total);
            service.lastCpu = { idle: idle, total: total };
        }
    }

    readonly property FileView memFile: FileView {
        path: "/proc/meminfo"
        onLoaded: {
            let info = {};
            for (let line of text().split("\n")) {
                let match = line.match(/^(\w+):\s+(\d+)/);
                if (match) info[match[1]] = Number(match[2]);
            }
            service.memTotal = info.MemTotal;
            service.memUsed = info.MemTotal - info.MemAvailable;
            service.swapTotal = info.SwapTotal;
            service.swapUsed = info.SwapTotal - info.SwapFree;
        }
    }

    readonly property FileView loadFile: FileView {
        path: "/proc/loadavg"
        onLoaded: service.loadAvg = text().split(" ").slice(0, 3).join("  ")
    }

    readonly property FileView uptimeFile: FileView {
        path: "/proc/uptime"
        onLoaded: service.uptime = Number(text().split(" ")[0])
    }

    // hwmon indexes change between boots, so the CPU sensor is looked up once by name
    readonly property Process tempFinder: Process {
        running: true
        command: ["sh", "-c", "for h in /sys/class/hwmon/hwmon*; do case $(cat $h/name) in k10temp|coretemp|zenpower|cpu_thermal) echo $h/temp1_input; exit;; esac; done"]
        stdout: StdioCollector {
            onStreamFinished: service.tempFile.path = text.trim()
        }
    }

    readonly property FileView tempFile: FileView {
        onLoaded: service.cpuTemp = Number(text()) / 1000
    }

    readonly property Process diskProcess: Process {
        running: true
        command: ["df", "-P", "-x", "tmpfs", "-x", "devtmpfs", "-x", "efivarfs", "-x", "overlay", "-x", "squashfs"]
        stdout: StdioCollector {
            onStreamFinished: {
                service.disks = text.trim().split("\n").slice(1).map(line => {
                    let cols = line.split(/\s+/);
                    return { mount: cols[5], total: Number(cols[2]) + Number(cols[3]), used: Number(cols[2]) };
                });
            }
        }
    }

    readonly property Timer pollTimer: Timer {
        interval: service.pollInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            service.statFile.reload();
            service.memFile.reload();
            service.loadFile.reload();
            service.uptimeFile.reload();
            if (service.tempFile.path !== "")
                service.tempFile.reload();
        }
    }

    readonly property Timer diskTimer: Timer {
        interval: service.diskPollInterval
        running: true
        repeat: true
        onTriggered: service.diskProcess.running = true
    }

    function toggleMenu() {
        menuOpen = !menuOpen;
    }
}
