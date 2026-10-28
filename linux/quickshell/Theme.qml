pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color bg: "#990d0e12"
    readonly property color panel: "#f20d0e12" // more opaque than the bar, for dropdowns over busy content
    readonly property color outline: "#12ffffff"
    readonly property color surface: "#14ffffff"
    readonly property color card: "#16181e"
    readonly property color text: "#d8d9de"
    readonly property color subtext: "#a3a6b3"
    readonly property color accent: "#ff69b4"
    readonly property color accentText: "#1e1f26"
    readonly property color green: "#a6da95"
    readonly property color red: "#ed8796"

    readonly property string fontFamily: "FiraCode Nerd Font"
    readonly property int fontSize: 13
    readonly property int barHeight: 32
    readonly property int chipHeight: 24
    readonly property int radius: 8
    readonly property int chipRadius: 5
    readonly property int gap: 5 // matches Hyprland gaps_out
    readonly property int anim: 150
}
