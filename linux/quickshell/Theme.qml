pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property color bg: "#eb0d0e12"
    readonly property color panel: "#f212131a" // more opaque than the bar, for dropdowns over busy content
    readonly property color outline: "#14ffffff"
    readonly property color surface: "#12ffffff"
    readonly property color surfaceHover: "#1fffffff"
    readonly property color card: "#0affffff"
    readonly property color shadow: "#99000000"
    readonly property color text: "#e6e7ec"
    readonly property color subtext: "#8b8e9c"
    readonly property color accent: "#ff69b4"
    readonly property color accentText: "#1e1f26"
    readonly property color green: "#a6da95"
    readonly property color red: "#ed8796"

    readonly property string fontFamily: "FiraCode Nerd Font"
    readonly property string iconFont: "FiraCode Nerd Font"
    readonly property int fontSize: 13
    readonly property int barHeight: 26
    readonly property int chipHeight: 26 // bar segments span the full bar height
    readonly property int radius: 8
    readonly property int cardRadius: 6
    readonly property int chipRadius: 4
    readonly property int gap: 5 // matches Hyprland gaps_out
    readonly property int shadowPad: 24 // room around floating panels for their shadow
    readonly property int anim: 150
    readonly property int animSlow: 220
}
