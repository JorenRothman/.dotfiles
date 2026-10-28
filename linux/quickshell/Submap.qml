import QtQuick

Block {
    property string name

    visible: name !== ""
    text: name
    color: Theme.highlight
    textColor: Theme.dark
    separator: false
    bottomLeftRadius: Theme.radius
    bottomRightRadius: Theme.radius
}
