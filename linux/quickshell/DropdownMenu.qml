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

    anchor {
        item: target
        edges: Edges.Bottom
        gravity: Edges.Bottom
        // Clear the island's bottom edge, then leave the usual gap
        margins.top: (Theme.barHeight - Theme.chipHeight) / 2 + Theme.gap
    }
    visible: open
    implicitWidth: 230
    implicitHeight: panel.height
    color: "transparent"

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
