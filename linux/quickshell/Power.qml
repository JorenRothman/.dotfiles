import QtQuick
import Quickshell

Block {
    hoverable: true
    color: hovered ? Theme.accent : "transparent"
    icon: ""
    iconColor: hovered ? Theme.accentText : Theme.accent
    onClicked: Quickshell.execDetached(["sh", "-c", "wlogout -l $HOME/.config/wlogout/layout"])
}
