import QtQuick
import Quickshell

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
    color: "transparent"

    Row {
        anchors.left: parent.left
        spacing: 20

        Workspaces {
            monitor: bar.screen.name
        }
        Submap {
            name: HyprState.submap
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter

        Clock {}
        Audio {}
    }

    Row {
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
}
