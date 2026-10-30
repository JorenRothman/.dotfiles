import QtQuick
import Quickshell
import Quickshell.Widgets

// Slider row in the volume dropdown; drives one or more nodes together
Item {
    id: root

    required property var nodes
    property string label
    property string iconName
    property string glyph: ""
    readonly property var audio: nodes[0]?.audio ?? null
    readonly property real volume: audio?.volume ?? 0
    readonly property bool muted: audio?.muted ?? false
    readonly property string iconPath: iconName !== "" ? Quickshell.iconPath(iconName, true) : ""

    function setVolume(value) {
        for (const node of nodes) {
            if (node?.audio)
                node.audio.volume = Math.max(0, Math.min(1, value));
        }
    }

    function toggleMute() {
        const next = !muted;
        for (const node of nodes) {
            if (node?.audio)
                node.audio.muted = next;
        }
    }

    width: parent?.width ?? 0
    implicitHeight: 46

    // Declared first so the mute button and slider sit above it and keep their clicks
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: w => root.setVolume(root.volume + (w.angleDelta.y > 0 ? 0.03 : -0.03))
    }

    Rectangle {
        id: mute

        anchors {
            left: parent.left
            leftMargin: 4
            verticalCenter: parent.verticalCenter
        }
        width: 32
        height: 32
        radius: Theme.chipRadius
        color: muteArea.containsMouse ? Theme.surfaceHover : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Theme.anim
            }
        }

        IconImage {
            anchors.centerIn: parent
            visible: root.iconPath !== ""
            implicitSize: 18
            source: root.iconPath
            opacity: root.muted ? 0.35 : 1
        }

        Icon {
            anchors.centerIn: parent
            visible: root.iconPath === ""
            text: root.muted ? "" : root.glyph
            color: root.muted ? Theme.red : Theme.accent
        }

        MouseArea {
            id: muteArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggleMute()
        }
    }

    BarText {
        anchors {
            left: mute.right
            leftMargin: 8
            right: percent.left
            rightMargin: 8
            top: parent.top
            topMargin: 5
        }
        text: root.label
        color: root.muted ? Theme.subtext : Theme.text
        elide: Text.ElideRight
    }

    BarText {
        id: percent
        anchors {
            right: parent.right
            rightMargin: 10
            top: parent.top
            topMargin: 5
        }
        text: root.muted ? "muted" : `${Math.round(root.volume * 100)}%`
        color: Theme.subtext
        font.pixelSize: 12
    }

    // The tall hit area makes the thin track easy to grab
    Item {
        id: slider

        anchors {
            left: mute.right
            leftMargin: 8
            right: parent.right
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 3
        }
        height: 16

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 4
            radius: 2
            color: Theme.surface

            Rectangle {
                width: parent.width * root.volume
                height: parent.height
                radius: parent.radius
                color: root.muted ? Theme.subtext : Theme.accent
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: (parent.width - width) * root.volume
            width: 10
            height: 10
            radius: 5
            color: root.muted ? Theme.subtext : Theme.text
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            preventStealing: true
            onPressed: m => root.setVolume(m.x / width)
            onPositionChanged: m => root.setVolume(m.x / width)
        }
    }
}
