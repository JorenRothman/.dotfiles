import QtQuick

// Floating rounded group of modules
Rectangle {
    default property alias content: row.data

    implicitWidth: row.implicitWidth + (Theme.barHeight - Theme.chipHeight)
    implicitHeight: Theme.barHeight
    radius: Theme.radius
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
