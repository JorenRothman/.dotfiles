import QtQuick

Rectangle {
    id: root

    property string icon
    property string text
    property string detail
    property color iconColor: Theme.accent
    // Destructive items need a second click; resets after a few seconds or when the menu closes
    property bool confirm: false
    property bool armed: false

    signal clicked

    width: parent?.width ?? 0
    implicitHeight: 30
    radius: Theme.chipRadius
    color: armed ? Theme.accent : area.containsMouse ? Theme.surface : "transparent"

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
            color: root.armed ? Theme.accentText : root.iconColor
        }
        BarText {
            text: root.armed ? "Click again to confirm" : root.text
            color: root.armed ? Theme.accentText : Theme.text
        }
    }

    BarText {
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        visible: !root.armed
        text: root.detail
        color: Theme.subtext
        font.pixelSize: 12
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.confirm && !root.armed) {
                root.armed = true;
                return;
            }
            root.armed = false;
            root.clicked();
        }
    }

    Timer {
        running: root.armed
        interval: 3000
        onTriggered: root.armed = false
    }
}
