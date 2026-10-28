import QtQuick

Rectangle {
    id: root

    property string icon
    property string text
    property string detail
    property color iconColor: Theme.accent

    signal clicked

    width: parent?.width ?? 0
    implicitHeight: 30
    radius: Theme.chipRadius
    color: area.containsMouse ? Theme.surface : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.anim
        }
    }

    Row {
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        spacing: 10

        BarText {
            width: 14
            horizontalAlignment: Text.AlignHCenter
            text: root.icon
            color: root.iconColor
        }
        BarText {
            text: root.text
        }
    }

    BarText {
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        text: root.detail
        color: Theme.subtext
        font.pixelSize: 12
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
