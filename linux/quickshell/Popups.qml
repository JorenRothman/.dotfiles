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
    // Padded past the cards so their shadows aren't clipped, pulled back so the cards keep their spot
    margins {
        top: Theme.gap - Theme.shadowPad
        right: Theme.gap - Theme.shadowPad
    }
    exclusiveZone: 0
    implicitWidth: 380 + Theme.shadowPad * 2
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

        x: Theme.shadowPad
        y: Theme.shadowPad
        width: parent.width - Theme.shadowPad * 2
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
