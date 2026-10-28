import QtQuick

// Group of modules aligned within the bar
Item {
    default property alias content: row.data

    implicitWidth: row.implicitWidth
    implicitHeight: Theme.barHeight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 2
    }
}
