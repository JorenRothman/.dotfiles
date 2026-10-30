import QtQuick
import Quickshell
import Quickshell.Io

// Connection state with Wi-Fi and WireGuard controls in a dropdown
Block {
    id: root

    required property var window
    readonly property string vpnServer: "162.55.40.2"
    property var devices: []
    property bool wifiEnabled: false
    property var networks: []
    property string ip: ""
    readonly property var wifiDevice: devices.find(d => d.type === "wifi") ?? null
    readonly property var wifi: devices.find(d => d.type === "wifi" && d.state === "connected") ?? null
    readonly property var wired: devices.find(d => d.type === "ethernet" && d.state === "connected") ?? null
    readonly property bool vpn: devices.some(d => d.type === "wireguard" && d.state === "connected")

    // nmcli -t separates fields with ":" and escapes any inside a value
    function fields(line) {
        return line.replace(/\\:/g, "\x00").split(":").map(f => f.replace(/\x00/g, ":"));
    }

    function refresh() {
        deviceList.running = true;
        radio.running = true;
    }

    function run(command) {
        menu.open = false;
        Quickshell.execDetached(command);
    }

    hoverable: true
    color: menu.open || hovered ? Theme.surfaceHover : "transparent"
    icon: wifi ? "" : wired ? "" : ""
    iconColor: wifi || wired ? Theme.subtext : Theme.red
    text: wifi ? wifi.connection : wired ? "Wired" : "Offline"
    textColor: wifi || wired ? Theme.text : Theme.subtext
    onClicked: menu.open = !menu.open

    Icon {
        anchors.verticalCenter: parent.verticalCenter
        visible: root.vpn
        text: ""
        color: Theme.green
    }

    Process {
        id: deviceList
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "device"]
        stdout: StdioCollector {
            onStreamFinished: root.devices = text.split("\n").filter(l => l).map(l => {
                const [device, type, state, connection] = root.fields(l);
                return {
                    device,
                    type,
                    state,
                    connection
                };
            })
        }
    }

    Process {
        id: radio
        command: ["nmcli", "radio", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: root.wifiEnabled = text.trim() === "enabled"
        }
    }

    Process {
        id: scan
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL", "device", "wifi", "list"]
        stdout: StdioCollector {
            // One row per SSID, strongest access point first
            onStreamFinished: {
                const seen = new Set();
                root.networks = text.split("\n").filter(l => l).map(l => {
                    const [inUse, ssid, signal] = root.fields(l);
                    return {
                        active: inUse === "*",
                        ssid,
                        signal: Number(signal)
                    };
                }).filter(n => n.ssid).sort((a, b) => b.active - a.active || b.signal - a.signal).filter(n => {
                    if (seen.has(n.ssid))
                        return false;
                    seen.add(n.ssid);
                    return true;
                }).slice(0, 8);
            }
        }
    }

    Process {
        id: ipFetch
        command: ["curl", "-s", "--max-time", "5", "https://ipinfo.io/ip"]
        stdout: StdioCollector {
            onStreamFinished: root.ip = text.trim()
        }
    }

    Process {
        id: vpnToggle
        command: ["nmcli", "connection", root.vpn ? "down" : "up", "WireGuard"]
        onExited: root.refresh()
    }

    // Prints a line on every network change; the timer collapses bursts into one refresh
    Process {
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: debounce.restart()
        }
    }

    Timer {
        id: debounce
        interval: 200
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()

    Connections {
        target: menu
        function onOpenChanged() {
            if (!menu.open)
                return;
            ipFetch.running = true;
            if (root.wifiEnabled)
                scan.running = true;
        }
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window
        menuWidth: 260

        Item {
            width: parent.width
            height: 30

            BarText {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: root.wifi ? "Wi-Fi" : root.wired ? "Ethernet" : "Network"
                font.weight: Font.DemiBold
            }
            BarText {
                anchors {
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: root.wifi || root.wired ? "Connected" : "Offline"
                color: root.wifi || root.wired ? Theme.green : Theme.subtext
                font.pixelSize: 12
            }
        }

        MenuItem {
            icon: ""
            iconColor: Theme.subtext
            text: "Copy public IP"
            detail: root.ip || "…"
            onClicked: {
                if (root.ip)
                    root.run(["wl-copy", root.ip]);
            }
        }

        MenuSeparator {
            visible: root.wifiDevice !== null
        }

        MenuItem {
            visible: root.wifiDevice !== null
            icon: ""
            iconColor: root.wifiEnabled ? Theme.accent : Theme.subtext
            text: root.wifiEnabled ? "Turn Wi-Fi off" : "Turn Wi-Fi on"
            onClicked: root.run(["nmcli", "radio", "wifi", root.wifiEnabled ? "off" : "on"])
        }

        Repeater {
            model: root.wifiEnabled ? root.networks : []

            MenuItem {
                required property var modelData

                icon: modelData.active ? "" : ""
                text: modelData.ssid
                detail: `${modelData.signal}%`
                onClicked: root.run(["nmcli", "device", "wifi", "connect", modelData.ssid])
            }
        }

        MenuSeparator {}

        MenuItem {
            icon: root.vpn ? "" : ""
            iconColor: root.vpn ? Theme.green : Theme.subtext
            text: vpnToggle.running ? "WireGuard…" : root.vpn ? "Disconnect WireGuard" : "Connect WireGuard"
            onClicked: {
                vpnToggle.running = true;
                menu.open = false;
            }
        }
        MenuItem {
            icon: ""
            iconColor: Theme.subtext
            text: "Copy VPN IP"
            detail: root.vpnServer
            onClicked: root.run(["wl-copy", root.vpnServer])
        }

        MenuSeparator {}

        MenuItem {
            icon: ""
            iconColor: Theme.subtext
            text: "Network settings"
            onClicked: root.run(["nm-connection-editor"])
        }
    }
}
