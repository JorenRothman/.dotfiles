import QtQuick

// One module inside an island: accent icon, value, optional dimmed detail
Rectangle {
    id: root

    property string icon
    property string text
    property string detail
    property color iconColor: Theme.subtext
    property color textColor: Theme.text
    property bool hoverable: false
    readonly property bool hovered: mouse.containsMouse
    default property alias content: row.data

    signal clicked(var mouse)
    signal scrolled(var wheel)

    implicitWidth: row.implicitWidth + 20
    implicitHeight: Theme.chipHeight
    radius: Theme.chipRadius
    color: hoverable && hovered ? Theme.surfaceHover : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.anim
        }
    }

    // Declared first so child items (tray icons) sit above it and get their own clicks
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
        spacing: 6

        Icon {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.icon !== ""
            text: root.icon
            color: root.iconColor
        }
        BarText {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.text !== ""
            text: root.text
            color: root.textColor
        }
        BarText {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.detail !== ""
            text: root.detail
            color: Theme.subtext
            font.weight: Font.Normal
        }
    }
}
