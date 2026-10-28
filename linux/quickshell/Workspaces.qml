import QtQuick

Row {
    id: root

    required property string monitor

    spacing: 0

    Repeater {
        // Named workspaces get negative ids counting down from -1337, so order them after numbered ones by creation
        model: HyprState.workspaces
            .filter(ws => ws.monitor === root.monitor && !ws.name.startsWith("special:"))
            .sort((a, b) => (a.id > 0 ? a.id : 1e6 - a.id) - (b.id > 0 ? b.id : 1e6 - b.id))

        // Tab spanning the full bar height, underlined when active
        Item {
            id: tab

            required property var modelData
            readonly property bool active: HyprState.activeByMonitor[root.monitor] === modelData.name

            implicitWidth: label.implicitWidth + 24
            implicitHeight: Theme.barHeight

            BarText {
                id: label
                anchors.centerIn: parent
                text: tab.modelData.name
                color: tab.active ? Theme.text : hover.containsMouse ? Theme.text : Theme.subtext
                font.weight: tab.active ? Font.Bold : Font.Medium
            }

            Rectangle {
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                width: tab.active ? parent.width - 12 : hover.containsMouse ? 8 : 0
                height: 2
                radius: 1
                color: tab.active ? Theme.accent : Theme.subtext

                Behavior on width {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Theme.anim
                    }
                }
            }

            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: HyprState.activate(tab.modelData.name)
            }
        }
    }
}
