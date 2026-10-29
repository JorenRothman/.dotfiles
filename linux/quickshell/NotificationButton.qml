import QtQuick

Block {
    required property string screenName

    readonly property int count: NotifState.all.length

    hoverable: true
    color: NotifState.centerOpen ? Theme.surface : hovered ? Theme.surfaceHover : "transparent"
    icon: NotifState.dnd ? "" : ""
    iconColor: count > 0 || NotifState.centerOpen ? Theme.accent : Theme.subtext
    text: count > 0 ? count : ""
    onClicked: NotifState.toggleCenter(screenName)
}
