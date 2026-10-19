import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: service

    readonly property int pollInterval: 2000 // In milliseconds
    readonly property int diskPollInterval: 5000 // Short enough to notice plugged drives

    // Usage ratios (0 to 1) above which a stat is considered critical
    readonly property real cpuCritical: 0.9
    readonly property real memCritical: 0.9
    readonly property real swapCritical: 0.8
    readonly property real diskCritical: 0.9
    readonly property real tempCritical: 85 // In °C

    property bool menuOpen: false
    property var screen: null // Monitor the menu opens on

    property real cpuUsage: 0
    property real cpuTemp: -1
    property real memTotal: 0 // In kB, like /proc/meminfo
    property real memUsed: 0
    property real swapTotal: 0
    property real swapUsed: 0
    property var disks: [] // [{ name, device, mountpoint, external, total, used }] in kB
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
        for (let disk of disks) {
            let icon = disk.external ? "\uf287" : "󰋊";
            let item = disk.mountpoint
                ? usage(icon, disk.name, disk.used, disk.total, diskCritical)
                : { icon: icon, label: disk.name, ratio: 0, text: "Not mounted · " + formatSize(disk.total), critical: false };
            item.disk = disk;
            list.push(item);
        }
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

    // The root filesystem, plus every mountable filesystem on hotplugged / removable drives
    readonly property Process diskProcess: Process {
        running: true
        command: ["lsblk", "-J", "-b", "-o", "NAME,PATH,FSTYPE,LABEL,SIZE,FSUSED,FSAVAIL,MOUNTPOINT,HOTPLUG,RM"]
        stdout: StdioCollector {
            onStreamFinished: {
                let flatten = devices => devices.reduce((all, d) => all.concat([d], flatten(d.children ?? [])), []);
                let all = flatten(JSON.parse(text).blockdevices);
                let unmountable = [null, "swap", "crypto_LUKS", "LVM2_member"];
                let main = all.filter(d => d.mountpoint === "/");
                let external = all.filter(d => (d.hotplug || d.rm) && !unmountable.includes(d.fstype));
                service.disks = [...main, ...external].map(d => ({
                    name: d.mountpoint === "/" ? "Disk /" : (d.label || d.name),
                    device: d.path,
                    mountpoint: d.mountpoint,
                    external: d.mountpoint !== "/",
                    total: d.mountpoint ? (Number(d.fsused) + Number(d.fsavail)) / 1024 : Number(d.size) / 1024,
                    used: Number(d.fsused) / 1024
                }));
            }
        }
    }

    readonly property Process udisksProcess: Process {
        onExited: service.diskProcess.running = true
    }

    function mount(device) {
        udisksProcess.command = ["udisksctl", "mount", "--no-user-interaction", "-b", device];
        udisksProcess.running = true;
    }

    function unmount(device) {
        udisksProcess.command = ["udisksctl", "unmount", "--no-user-interaction", "-b", device];
        udisksProcess.running = true;
    }

    function open(path) {
        Quickshell.execDetached(["xdg-open", path]);
        menuOpen = false;
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

    // Clicking from another monitor moves the menu there instead of closing it
    function toggleMenu(screen) {
        menuOpen = !menuOpen || service.screen !== screen;
        service.screen = screen;
    }
}
