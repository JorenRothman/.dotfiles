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
    // matching the notification center's distance from the bar
    anchor {
        item: target
        rect {
            x: 0
            y: target.height + (Theme.barHeight - Theme.chipHeight) / 2 + Theme.gap
            width: target.width
            height: 1
        }
        edges: Edges.Top
        gravity: Edges.Bottom
    }
    visible: open
    implicitWidth: 230
    implicitHeight: panel.height
    color: "transparent"

    // Disarm any confirm items so a closed menu never reopens one click away from firing
    onOpenChanged: {
        if (open)
            return;
        for (const item of column.children)
            if (item.armed)
                item.armed = false;
    }

    // Activated after the window maps; binding it to visible directly loops when the grab clears instantly
    onVisibleChanged: Qt.callLater(() => grab.active = root.visible)

    HyprlandFocusGrab {
        id: grab
        windows: [root, root.bar]
        onCleared: root.open = false
    }

    Rectangle {
        id: panel

        width: parent.width
        height: column.implicitHeight + 12
        radius: Theme.radius
        color: Theme.bg
        border {
            width: 1
            color: Theme.outline
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
