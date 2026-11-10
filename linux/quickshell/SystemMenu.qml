import QtQuick
import Quickshell
import Quickshell.Io

// System overview shared by the CPU and memory segments: CPU, GPU, memory, disk and top apps
DropdownMenu {
    id: root

    required property var cpu
    required property var memory
    readonly property real gib: 1024 * 1024
    readonly property var mem: memory.mem
    readonly property real swapTotal: (mem.SwapTotal ?? 0) / gib
    readonly property real swapUsed: ((mem.SwapTotal ?? 0) - (mem.SwapFree ?? 0)) / gib
    property var info: ({})
    readonly property real cpuWatts: info.cpupower ? info.cpupower[0] / 1e6 : -1
    readonly property real gpuWatts: info.gpu ? info.gpu[4] : -1
    property var apps: []

    // Opens under whichever segment was clicked; clicking the same one again closes it
    function toggle(item) {
        if (open && target === item) {
            open = false;
            return;
        }
        target = item;
        if (open)
            place();
        open = true;
    }

    function run(command) {
        open = false;
        Quickshell.execDetached(command);
    }

    function fmt(g) {
        return g >= 100 ? `${g.toFixed(0)}G` : g >= 1 ? `${g.toFixed(1)}G` : `${Math.round(g * 1024)}M`;
    }

    function pct(f) {
        return `${Math.round(100 * f)}%`;
    }

    function duration(s) {
        const d = Math.floor(s / 86400), h = Math.floor(s % 86400 / 3600), m = Math.floor(s % 3600 / 60);
        return d > 0 ? `${d}d ${h}h` : h > 0 ? `${h}h ${m}m` : `${m}m`;
    }

    menuWidth: 280

    Process {
        id: probe
        command: ["sh", Quickshell.shellDir + "/scripts/sysinfo.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                const info = {};
                const sums = {};
                for (const line of text.split("\n")) {
                    const [key, ...rest] = line.trim().split(/\s+/);
                    if (key === "proc") {
                        const name = rest.slice(1).join(" ");
                        sums[name] = (sums[name] ?? 0) + Number(rest[0]);
                    } else if (key) {
                        info[key] = rest.map(Number);
                    }
                }
                root.info = info;
                // Resident memory summed per command, so multi-process apps (browsers, electron) show as one
                root.apps = Object.entries(sums).sort((a, b) => b[1] - a[1]).slice(0, 5).map(([name, kb]) => ({
                            name,
                            size: kb / root.gib
                        }));
            }
        }
    }

    Timer {
        interval: 2000
        running: root.open
        repeat: true
        triggeredOnStart: true
        onTriggered: probe.running = true
    }

    // Header
    StatRow {
        height: 30
        heading: true
        label: "System"
        value: root.info.uptime ? `up ${root.duration(root.info.uptime[0])}` : ""
    }

    // CPU
    StatRow {
        heading: true
        label: "CPU"
        value: root.pct(root.cpu.usage / 100) + (root.info.cputemp ? `  ${Math.round(root.info.cputemp[0] / 1000)}°C` : "")
    }
    Meter {
        fraction: root.cpu.usage / 100
    }
    Spacer {}
    StatRow {
        visible: !!root.info.load
        label: "Load"
        value: root.info.load ? root.info.load.map(l => l.toFixed(2)).join("  ") : ""
        valueColor: root.info.load && root.info.cores && root.info.load[0] > root.info.cores[0] ? Theme.red : Theme.text
    }

    // GPU
    MenuSeparator {
        visible: !!root.info.gpu
    }
    StatRow {
        visible: !!root.info.gpu
        heading: true
        label: "GPU"
        value: root.info.gpu ? `${root.info.gpu[0]}%  ${root.info.gpu[3]}°C` : ""
    }
    Meter {
        visible: !!root.info.gpu
        fraction: root.info.gpu ? root.info.gpu[0] / 100 : 0
    }
    Spacer {
        visible: !!root.info.gpu
    }
    StatRow {
        visible: !!root.info.gpu
        label: "VRAM"
        value: root.info.gpu ? `${root.fmt(root.info.gpu[1] / 1024)} / ${root.fmt(root.info.gpu[2] / 1024)}` : ""
    }

    // Power: what the sensors cover (CPU socket + GPU board), not the whole machine at the wall
    MenuSeparator {
        visible: root.cpuWatts >= 0 || root.gpuWatts >= 0
    }
    StatRow {
        visible: root.cpuWatts >= 0 || root.gpuWatts >= 0
        heading: true
        label: "Power"
        value: `${Math.round(Math.max(0, root.cpuWatts) + Math.max(0, root.gpuWatts))} W`
    }
    StatRow {
        visible: root.cpuWatts >= 0
        label: "CPU"
        value: `${Math.round(root.cpuWatts)} W`
    }
    StatRow {
        visible: root.gpuWatts >= 0
        label: "GPU"
        value: `${Math.round(root.gpuWatts)} W`
    }

    // Memory
    MenuSeparator {}
    StatRow {
        heading: true
        label: "Memory"
        value: `${root.fmt(root.memory.used)} / ${root.fmt(root.memory.total)}`
    }
    Meter {
        fraction: root.memory.total > 0 ? root.memory.used / root.memory.total : 0
    }
    Spacer {}
    StatRow {
        label: "Available"
        value: root.fmt((root.mem.MemAvailable ?? 0) / root.gib)
    }
    StatRow {
        label: "Cached"
        value: root.fmt(((root.mem.Cached ?? 0) + (root.mem.Buffers ?? 0)) / root.gib)
    }
    StatRow {
        visible: root.swapTotal > 0
        label: "Swap"
        value: `${root.fmt(root.swapUsed)} / ${root.fmt(root.swapTotal)}`
        valueColor: root.swapUsed / root.swapTotal > 0.5 ? Theme.red : Theme.text
    }

    // Disk
    MenuSeparator {
        visible: !!root.info.disk
    }
    StatRow {
        visible: !!root.info.disk
        heading: true
        label: "Disk"
        value: root.info.disk ? `${root.fmt(root.info.disk[1] / 1024 ** 3)} / ${root.fmt(root.info.disk[0] / 1024 ** 3)}` : ""
    }
    Meter {
        visible: !!root.info.disk
        fraction: root.info.disk ? root.info.disk[1] / root.info.disk[0] : 0
    }
    Spacer {
        visible: !!root.info.disk
    }

    // Top apps by memory
    MenuSeparator {
        visible: root.apps.length > 0
    }
    StatRow {
        visible: root.apps.length > 0
        heading: true
        label: "Top apps"
        value: "memory"
    }
    Repeater {
        model: root.apps

        StatRow {
            required property var modelData

            label: modelData.name
            value: root.fmt(modelData.size)
        }
    }

    MenuSeparator {}

    MenuItem {
        icon: ""
        iconColor: Theme.subtext
        text: "Open btop"
        onClicked: root.run(["ghostty", "-e", "btop"])
    }

    component Spacer: Item {
        width: parent?.width ?? 0
        height: 4
    }
}
