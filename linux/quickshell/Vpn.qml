import QtQuick
import Quickshell
import Quickshell.Io

Block {
    id: root

    property bool connected: false

    hoverable: true
    text: connected ? "🔒 Connected" : "🔓 Disconnected"

    onClicked: m => {
        if (m.button === Qt.LeftButton)
            Quickshell.execDetached(["nmcli", "connection", "up", "WireGuard"]);
        else if (m.button === Qt.RightButton)
            Quickshell.execDetached(["nmcli", "connection", "down", "WireGuard"]);
        else if (m.button === Qt.MiddleButton)
            Quickshell.execDetached(["wl-copy", "162.55.40.2"]);
    }

    Process {
        id: check
        command: ["ip", "addr", "show"]
        stdout: StdioCollector {
            onStreamFinished: root.connected = text.includes("Joren-Linux")
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: check.running = true
    }
}
