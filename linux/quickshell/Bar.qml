import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: bar

    required property ShellScreen modelData

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    color: Theme.bg
    WlrLayershell.namespace: "quickshell"

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: 1
        color: Theme.outline
    }

    Island {
        anchors.left: parent.left

        Workspaces {
            monitor: bar.screen.name
        }
        Submap {
            name: HyprState.submap
        }
    }

    Island {
        anchors.horizontalCenter: parent.horizontalCenter

        Clock {}
        NotificationButton {
            screenName: bar.screen.name
        }
    }

    Island {
        anchors.right: parent.right

        Ssh {
            window: bar
        }
        Docker {
            window: bar
        }
        Cpu {}
        Memory {}
        Vpn {
            window: bar
        }
        ExternalIp {}
        Audio {}
        Tray {
            window: bar
        }
        Power {
            window: bar
        }
    }

    NotificationCenter {
        bar: bar
        screen: bar.screen
    }
}
