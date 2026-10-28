import QtQuick
import Quickshell

Block {
    padding: 24
    separator: false
    color: hovered ? Theme.highlight : Theme.dark
    textColor: hovered ? Theme.dark : Theme.light
    text: ""
    onClicked: Quickshell.execDetached(["sh", "-c", "wlogout -l $HOME/.config/wlogout/layout"])
}
