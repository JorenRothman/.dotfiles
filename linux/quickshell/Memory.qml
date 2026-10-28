import QtQuick
import Quickshell
import Quickshell.Io

Block {
    id: root

    property real used: 0
    property real total: 0

    hoverable: true
    text: `RAM: ${used.toFixed(2)} / ${total.toFixed(0)} GB`
    onClicked: Quickshell.execDetached(["alacritty", "-e", "btop"])

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: {
            const kb = key => Number(text().match(new RegExp(`^${key}:\\s+(\\d+)`, "m"))[1]);
            const gib = 1024 * 1024;
            root.total = kb("MemTotal") / gib;
            root.used = (kb("MemTotal") - kb("MemAvailable")) / gib;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: meminfo.reload()
    }
}
