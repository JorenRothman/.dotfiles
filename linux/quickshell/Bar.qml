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
    margins {
        top: Theme.gap
        left: Theme.gap
        right: Theme.gap
    }
    implicitHeight: Theme.barHeight
    color: "transparent"
    WlrLayershell.namespace: "quickshell"

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
        Audio {}
    }

    Island {
        anchors.right: parent.right

        Cpu {}
        Memory {}
        Vpn {}
        ExternalIp {}
        Tray {
            window: bar
        }
        Power {}
    }

    NotificationCenter {
        bar: bar
        screen: bar.screen
    }
}
