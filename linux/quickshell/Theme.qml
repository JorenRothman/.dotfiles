pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color bg: "#e01e1f26"
    readonly property color outline: "#14ffffff"
    readonly property color surface: "#2c2e3a"
    readonly property color card: "#24262f"
    readonly property color text: "#e0e0e0"
    readonly property color subtext: "#8b8fa3"
    readonly property color accent: "#ff69b4"
    readonly property color accentText: "#1e1f26"
    readonly property color green: "#a6da95"
    readonly property color red: "#ed8796"

    readonly property string fontFamily: "FiraCode Nerd Font"
    readonly property int fontSize: 13
    readonly property int barHeight: 34
    readonly property int chipHeight: 26
    readonly property int radius: 10
    readonly property int chipRadius: 7
    readonly property int gap: 5 // matches Hyprland gaps_out
    readonly property int anim: 150
}
