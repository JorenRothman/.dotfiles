import QtQuick
import Quickshell.Io

Block {
    id: root

    property int usage: 0
    property var prev: null

    icon: "\uf4bc"
    text: `${String(usage).padStart(2)}%`

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: {
            const fields = text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
            const total = fields.reduce((a, b) => a + b, 0);
            const idle = fields[3] + fields[4]; // idle + iowait
            if (root.prev) {
                const dt = total - root.prev.total;
                if (dt > 0)
                    root.usage = Math.round(100 * (dt - (idle - root.prev.idle)) / dt);
            }
            root.prev = { total, idle };
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: stat.reload()
    }
}
