import QtQuick
import Quickshell
import Quickshell.Io

// RAM usage; opens the system menu
Block {
    id: root

    required property var menu
    readonly property real gib: 1024 * 1024
    property var mem: ({})
    readonly property real total: (mem.MemTotal ?? 0) / gib
    readonly property real used: ((mem.MemTotal ?? 0) - (mem.MemAvailable ?? 0)) / gib

    hoverable: true
    color: (menu.open && menu.target === root) || hovered ? Theme.surfaceHover : "transparent"
    icon: String.fromCodePoint(0xf035b)
    text: `${used.toFixed(1)}G`
    detail: `/ ${total.toFixed(0)}G`
    onClicked: m => {
        if (m.button === Qt.MiddleButton)
            Quickshell.execDetached(["ghostty", "-e", "btop"]);
        else
            menu.toggle(root);
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: {
            const mem = {};
            const re = /^(\w+):\s+(\d+)/gm;
            const src = text();
            let m;
            while ((m = re.exec(src)))
                mem[m[1]] = Number(m[2]);
            root.mem = mem;
        }
    }

    Timer {
        interval: root.menu.open ? 2000 : 5000
        running: true
        repeat: true
        onTriggered: meminfo.reload()
    }
}
