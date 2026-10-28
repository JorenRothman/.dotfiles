import QtQuick
import Quickshell
import Quickshell.Wayland

// One per screen; moving a single window between screens crashes Quickshell on reload
PanelWindow {
    id: root

    required property ShellScreen modelData

    screen: modelData
    visible: NotifState.popupScreen === modelData.name
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
    implicitHeight: modelData.height * 0.8
    color: "transparent"
    mask: Region {
        item: list
    }
    WlrLayershell.namespace: "quickshell-notifications"
    WlrLayershell.layer: WlrLayer.Overlay

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
            // Only the visible window instantiates cards, so each popup counts down once
            model: root.visible ? NotifState.popups : 0

            NotificationCard {
                width: list.width
                popup: true
                onTimedOut: NotifState.popupTimedOut(nid)
            }
        }
    }
}
