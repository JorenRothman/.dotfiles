import QtQuick

Item {
    width: parent?.width ?? 0
    height: 9

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            margins: 8
            verticalCenter: parent.verticalCenter
        }
        height: 1
        color: Theme.outline
    }
}
