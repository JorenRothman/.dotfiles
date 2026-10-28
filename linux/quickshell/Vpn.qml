import QtQuick
import Quickshell
import Quickshell.Io

Block {
    id: root

    required property var window
    property bool connected: false
    readonly property string server: "162.55.40.2"

    hoverable: true
    color: menu.open || hovered ? Theme.surface : "transparent"
    icon: connected ? "" : ""
    iconColor: connected ? Theme.green : Theme.red
    text: "VPN"
    textColor: connected ? Theme.text : Theme.subtext
    onClicked: menu.open = !menu.open

    Process {
        id: check
        command: ["ip", "addr", "show"]
        stdout: StdioCollector {
            onStreamFinished: root.connected = text.includes("Joren-Linux")
        }
    }

    Process {
        id: toggle
        command: ["nmcli", "connection", root.connected ? "down" : "up", "WireGuard"]
        onExited: check.running = true
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: check.running = true
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window

        Item {
            width: parent.width
            height: 30

            BarText {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: "WireGuard"
                font.weight: Font.Bold
            }
            BarText {
                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: toggle.running ? "…" : root.connected ? "Connected" : "Disconnected"
                color: root.connected ? Theme.green : Theme.subtext
                font.pixelSize: 12
            }
        }

        MenuSeparator {}

        MenuItem {
            icon: root.connected ? "" : ""
            text: root.connected ? "Disconnect" : "Connect"
            onClicked: {
                toggle.running = true;
                menu.open = false;
            }
        }
        MenuItem {
            icon: ""
            text: "Copy IP"
            detail: root.server
            onClicked: {
                Quickshell.execDetached(["wl-copy", root.server]);
                menu.open = false;
            }
        }
    }
}
