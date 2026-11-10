import QtQuick

// Label on the left, value on the right; for read-only rows in dropdowns
Item {
    property bool heading: false
    property string label
    property string value
    property color valueColor: Theme.text

    width: parent?.width ?? 0
    height: 24

    BarText {
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        text: parent.label
        color: parent.heading ? Theme.text : Theme.subtext
        font.weight: parent.heading ? Font.DemiBold : Font.Medium
        elide: Text.ElideRight
        width: Math.min(implicitWidth, parent.width * 0.55)
    }
    BarText {
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        text: parent.value
        color: parent.heading ? Theme.subtext : parent.valueColor
        font.pixelSize: parent.heading ? 12 : Theme.fontSize
    }
}
