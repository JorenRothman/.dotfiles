import QtQuick

// Floating pill grouping modules within the bar
Rectangle {
    default property alias content: row.data

    implicitWidth: row.implicitWidth + 8
    implicitHeight: Theme.barHeight
    radius: Theme.chipRadius + 4 // concentric with the chips inside
    color: Theme.bg
    border {
        width: 1
        color: Theme.outline
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 2
    }
}
