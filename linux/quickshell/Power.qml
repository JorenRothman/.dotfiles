import QtQuick
import Quickshell

Block {
    id: root

    required property var window

    function run(command) {
        menu.open = false;
        Quickshell.execDetached(["sh", "-c", command]);
    }

    hoverable: true
    color: menu.open || hovered ? Theme.accent : "transparent"
    icon: ""
    iconColor: menu.open || hovered ? Theme.accentText : Theme.accent
    onClicked: menu.open = !menu.open

    DropdownMenu {
        id: menu

        target: root
        bar: root.window

        MenuItem {
            icon: ""
            text: "Lock"
            onClicked: root.run("hyprlock")
        }

        MenuSeparator {}

        // hyprshutdown closes apps gracefully before leaving Hyprland
        MenuItem {
            icon: ""
            text: "Log out"
            confirm: true
            onClicked: root.run("hyprshutdown -t 'Logging out...'")
        }
        MenuItem {
            icon: ""
            iconColor: Theme.red
            text: "Shut down"
            confirm: true
            onClicked: root.run("hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'")
        }
    }
}
