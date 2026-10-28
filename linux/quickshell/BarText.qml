import QtQuick

Text {
    color: Theme.text
    font {
        family: Theme.fontFamily
        pixelSize: Theme.fontSize
        weight: Font.Medium
    }

    Behavior on color {
        ColorAnimation {
            duration: Theme.anim
        }
    }
}
