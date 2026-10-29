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
    property bool selected: false // keyboard highlight

    signal clicked

    width: parent?.width ?? 0
    implicitHeight: 32
    radius: Theme.chipRadius
    color: armed ? Theme.accent : area.containsMouse || selected ? Theme.surfaceHover : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.anim
        }
    }

    Icon {
        id: glyph
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        width: 16
        horizontalAlignment: Text.AlignHCenter
        text: root.icon
        color: root.armed ? Theme.accentText : root.iconColor
    }

    // Label and detail share the row; both elide rather than overlap
    BarText {
        anchors {
            left: glyph.right
            leftMargin: 10
            right: detailText.visible ? detailText.left : parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        text: root.armed ? "Click again to confirm" : root.text
        color: root.armed ? Theme.accentText : Theme.text
        elide: Text.ElideRight
    }

    BarText {
        id: detailText
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        width: Math.min(implicitWidth, root.width * 0.45)
        visible: !root.armed && root.detail !== ""
        text: root.detail
        color: Theme.subtext
        font.pixelSize: 12
        elide: Text.ElideMiddle
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
