import QtQuick

Block {
    id: root

    required property string monitor

    separator: false
    bottomRightRadius: Theme.radius

    Repeater {
        // Named workspaces get negative ids counting down from -1337, so order them after numbered ones by creation
        model: HyprState.workspaces
            .filter(ws => ws.monitor === root.monitor && !ws.name.startsWith("special:"))
            .sort((a, b) => (a.id > 0 ? a.id : 1e6 - a.id) - (b.id > 0 ? b.id : 1e6 - b.id))

        BarText {
            required property var modelData

            text: modelData.name
            color: HyprState.activeByMonitor[root.monitor] === modelData.name || hover.containsMouse ? Theme.highlight : Theme.light

            MouseArea {
                id: hover
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: HyprState.activate(parent.modelData.name)
            }
        }
    }
}
