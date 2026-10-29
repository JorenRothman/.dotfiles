import QtQuick

Text {
    color: Theme.text
    font {
        family: Theme.fontFamily
        pixelSize: Theme.fontSize
        weight: Font.Medium
        features: {
            "tnum": 1 // tabular digits so changing numbers don't jitter
        }
    }
    renderType: Text.NativeRendering

    Behavior on color {
        ColorAnimation {
            duration: Theme.anim
        }
    }
}
