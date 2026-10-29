import QtQuick
import Quickshell
import Quickshell.Hyprland

// Small menu that drops down below a bar module
PopupWindow {
    id: root

    required property Item target
    required property var bar
    property bool open: false
    default property alias items: column.data

    // Hang from a line below the module: past the island's bottom padding, then the usual gap,
    // matching the notification center's distance from the bar. The window extends past the
    // panel on every side to leave room for its shadow.
    anchor {
        item: target
        rect {
            x: 0
            y: target.height + (Theme.barHeight - Theme.chipHeight) / 2 + Theme.gap - Theme.shadowPad
            width: target.width
            height: 1
        }
        edges: Edges.Top
        gravity: Edges.Bottom
    }
    // Stays mapped until the fade-out finishes
    visible: open || panel.opacity > 0
    implicitWidth: 230 + Theme.shadowPad * 2
    implicitHeight: panel.height + Theme.shadowPad * 2
    color: "transparent"
    mask: Region {
        item: panel
    }

    // Disarm any confirm items so a closed menu never reopens one click away from firing
    onOpenChanged: {
        // Activated after the window maps; binding it directly loops when the grab clears instantly
        Qt.callLater(() => grab.active = root.open);
        if (open)
            return;
        for (const item of column.children)
            if (item.armed)
                item.armed = false;
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root, root.bar]
        onCleared: root.open = false
    }

    Shadow {
        anchors.fill: panel
        opacity: panel.opacity
    }

    Rectangle {
        id: panel

        x: Theme.shadowPad
        y: Theme.shadowPad + (root.open ? 0 : -6)
        width: parent.width - Theme.shadowPad * 2
        height: column.implicitHeight + 12
        radius: Theme.radius
        color: Theme.panel
        opacity: root.open ? 1 : 0
        border {
            width: 1
            color: Theme.outline
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.anim
                easing.type: Easing.OutCubic
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: Theme.animSlow
                easing.type: Easing.OutCubic
            }
        }

        Column {
            id: column

            x: 6
            y: 6
            width: parent.width - 12
            spacing: 2
        }
    }
}
