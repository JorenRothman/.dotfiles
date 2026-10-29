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
    // Islands float one gap below the screen edge, like the windows below them
    implicitHeight: Theme.barHeight + Theme.gap
    color: "transparent"
    WlrLayershell.namespace: "quickshell"

    Island {
        y: Theme.gap
        anchors.left: parent.left
        anchors.leftMargin: Theme.gap

        Workspaces {
            monitor: bar.screen.name
        }
        Submap {
            name: HyprState.submap
        }
    }

    Island {
        y: Theme.gap
        anchors.horizontalCenter: parent.horizontalCenter

        Clock {}
        NotificationButton {
            screenName: bar.screen.name
        }
    }

    Island {
        y: Theme.gap
        anchors.right: parent.right
        anchors.rightMargin: Theme.gap

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
