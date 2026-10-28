import QtQuick

Block {
    property string name

    anchors.verticalCenter: parent.verticalCenter
    visible: name !== ""
    color: Theme.accent
    icon: "\uf11c"
    iconColor: Theme.accentText
    text: name
    textColor: Theme.accentText
}
