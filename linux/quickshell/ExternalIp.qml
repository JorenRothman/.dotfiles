import QtQuick
import Quickshell
import Quickshell.Io

Block {
    id: root

    property string ip: ""

    hoverable: true
    icon: "\uf0ac"
    text: ip || "…"
    textColor: Theme.subtext
    onClicked: if (ip) Quickshell.execDetached(["wl-copy", ip])

    Process {
        id: fetch
        command: ["curl", "-s", "--max-time", "5", "https://ipinfo.io/ip"]
        stdout: StdioCollector {
            onStreamFinished: root.ip = text.trim()
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetch.running = true
    }
}
