import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    // Follow the focused monitor, but only between bursts so visible popups don't jump screens
    property string screenName: HyprState.focusedMonitor

    screen: Quickshell.screens.find(s => s.name === screenName) ?? Quickshell.screens[0]
    anchors {
        top: true
        right: true
    }
    margins {
        top: Theme.gap
        right: Theme.gap
    }
    exclusiveZone: 0
    implicitWidth: 380
    implicitHeight: (screen?.height ?? 1080) * 0.8
    color: "transparent"
    mask: Region {
        item: list
    }
    WlrLayershell.namespace: "quickshell-notifications"
    WlrLayershell.layer: WlrLayer.Overlay

    Connections {
        target: HyprState

        function onFocusedMonitorChanged() {
            if (NotifState.popups.count === 0)
                root.screenName = HyprState.focusedMonitor;
        }
    }

    // A Column rather than a ListView: cards settle their height after being laid out,
    // and ListView keeps the stale positions from its transitions, eating the spacing
    Column {
        id: list

        width: parent.width
        spacing: 8

        move: Transition {
            NumberAnimation {
                property: "y"
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Repeater {
            model: NotifState.popups

            NotificationCard {
                width: list.width
                popup: true
                onTimedOut: NotifState.popupTimedOut(nid)
            }
        }
    }
}
