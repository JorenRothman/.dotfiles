import QtQuick

// Equivalent of a waybar module: dark box, optional right border, hover + click/scroll
Rectangle {
    id: root

    property string text
    property color textColor: hoverable && hovered ? Theme.highlight : Theme.light
    property bool hoverable: false
    property bool separator: true
    property int padding: 12
    readonly property bool hovered: mouse.containsMouse
    default property alias content: row.data

    signal clicked(var mouse)
    signal scrolled(var wheel)

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: Theme.barHeight
    color: Theme.dark

    // Declared first so child items (tray icons, workspaces) sit above it and get their own clicks
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: root.hoverable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: m => root.clicked(m)
        onWheel: w => root.scrolled(w)
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8

        BarText {
            visible: root.text !== ""
            text: root.text
            color: root.textColor
        }
    }

    Rectangle {
        visible: root.separator
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: 1
        color: Theme.border
    }
}
