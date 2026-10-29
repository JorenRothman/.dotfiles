import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// Small menu that drops down below a bar module. A layer surface rather than a popup,
// since only layer surfaces can take keyboard focus for menus that want typing.
PanelWindow {
    id: root

    required property Item target
    required property var bar
    property bool open: false
    property bool keyboard: false
    property int menuWidth: 230
    default property alias items: column.data

    // Centered under the module, kept on screen; measured on open since modules shift as they resize
    function place() {
        const center = target.mapToItem(null, target.width / 2, 0).x;
        margins.left = Math.max(0, Math.min(center - implicitWidth / 2, bar.width - implicitWidth));
    }

    screen: bar.screen
    // Stays mapped until the fade-out finishes. The window extends past the panel on every side
    // to leave room for its shadow, pulled up so the panel still sits one gap below the bar.
    visible: open || panel.opacity > 0
    anchors {
        top: true
        left: true
    }
    margins.top: Theme.gap - Theme.shadowPad
    exclusiveZone: 0
    implicitWidth: menuWidth + Theme.shadowPad * 2
    implicitHeight: panel.height + Theme.shadowPad * 2
    color: "transparent"
    mask: Region {
        item: panel
    }
    WlrLayershell.namespace: "quickshell-menu"
    WlrLayershell.keyboardFocus: keyboard && open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Disarm any confirm items so a closed menu never reopens one click away from firing
    onOpenChanged: {
        if (open)
            place();
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
