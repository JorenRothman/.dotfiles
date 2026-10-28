import QtQuick

Row {
    id: root

    required property string monitor

    spacing: 2

    Repeater {
        // Named workspaces get negative ids counting down from -1337, so order them after numbered ones by creation
        model: HyprState.workspaces
            .filter(ws => ws.monitor === root.monitor && !ws.name.startsWith("special:"))
            .sort((a, b) => (a.id > 0 ? a.id : 1e6 - a.id) - (b.id > 0 ? b.id : 1e6 - b.id))

        Rectangle {
            id: pill

            required property var modelData
            readonly property bool active: HyprState.activeByMonitor[root.monitor] === modelData.name

            implicitWidth: label.implicitWidth + 20
            implicitHeight: Theme.chipHeight
            radius: Theme.chipRadius
            color: active ? Theme.accent : hover.containsMouse ? Theme.surface : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anim
                }
            }

            BarText {
                id: label
                anchors.centerIn: parent
                text: pill.modelData.name
                color: pill.active ? Theme.accentText : hover.containsMouse ? Theme.text : Theme.subtext
                font.weight: pill.active ? Font.Bold : Font.Medium
            }

            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: HyprState.activate(pill.modelData.name)
            }
        }
    }
}
