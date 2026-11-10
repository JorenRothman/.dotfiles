import QtQuick

// Thin usage bar that turns red near full
Rectangle {
    property real fraction: 0

    x: 10
    width: (parent?.width ?? 20) - 20
    height: 6
    radius: 3
    color: Theme.surface

    Rectangle {
        width: parent.width * Math.max(0, Math.min(1, parent.fraction))
        height: parent.height
        radius: parent.radius
        color: parent.fraction > 0.85 ? Theme.red : Theme.accent

        Behavior on width {
            NumberAnimation {
                duration: Theme.animSlow
                easing.type: Easing.OutCubic
            }
        }
    }
}
