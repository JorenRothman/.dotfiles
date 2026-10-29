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

        // Full-height segment, filled with the accent when active
        Rectangle {
            id: tab

            required property var modelData
            readonly property bool active: HyprState.activeByMonitor[root.monitor] === modelData.name

            implicitWidth: label.implicitWidth + 24
            implicitHeight: Theme.barHeight
            color: active ? Theme.accent : hover.containsMouse ? Theme.surfaceHover : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: Theme.anim
                }
            }

            BarText {
                id: label
                anchors.centerIn: parent
                text: tab.modelData.name
                color: tab.active ? Theme.accentText : hover.containsMouse ? Theme.text : Theme.subtext
                font.weight: tab.active ? Font.DemiBold : Font.Medium
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
