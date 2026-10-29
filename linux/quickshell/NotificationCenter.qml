import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// Dropdown under the bar's center island
PanelWindow {
    id: root

    required property var bar

    readonly property bool shown: NotifState.centerOpen && NotifState.centerScreen === bar.screen.name

    // Stays mapped until the fade-out finishes. The window extends past the panel on every side
    // to leave room for its shadow, pulled up so the panel still sits one gap below the bar
    visible: shown || panel.opacity > 0
    anchors.top: true
    margins.top: Theme.gap - Theme.shadowPad
    exclusiveZone: 0
    implicitWidth: 420 + Theme.shadowPad * 2
    implicitHeight: panel.height + Theme.shadowPad * 2
    color: "transparent"
    mask: Region {
        item: panel
    }
    WlrLayershell.namespace: "quickshell-notifications"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // Clicking anywhere outside the panel or the bar closes it
    // Activated after the window maps; binding it directly loops when the grab clears instantly
    onShownChanged: Qt.callLater(() => grab.active = root.shown)

    HyprlandFocusGrab {
        id: grab
        windows: [root, root.bar]
        onCleared: NotifState.centerOpen = false
    }

    Shadow {
        anchors.fill: panel
        opacity: panel.opacity
    }

    Rectangle {
        id: panel

        x: Theme.shadowPad
        y: Theme.shadowPad + (root.shown ? 0 : -8)
        width: parent.width - Theme.shadowPad * 2
        height: Math.min(header.height + body.height + 38, (root.screen?.height ?? 1080) * 0.7)
        radius: Theme.radius
        color: Theme.panel
        opacity: root.shown ? 1 : 0
        border {
            width: 1
            color: Theme.outline
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.anim
                easing.type: Easing.OutCubic
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: Theme.animSlow
                easing.type: Easing.OutCubic
            }
        }

        focus: true
        Keys.onEscapePressed: NotifState.centerOpen = false

        Item {
            id: header

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 14
            }
            height: Theme.chipHeight

            Row {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 4
                spacing: 7

                BarText {
                    text: "Notifications"
                    font.weight: Font.DemiBold
                }
                BarText {
                    visible: NotifState.all.length > 0
                    text: NotifState.all.length
                    color: Theme.subtext
                }
            }

            Row {
                anchors.right: parent.right
                spacing: 2

                Block {
                    hoverable: true
                    icon: NotifState.dnd ? "" : ""
                    iconColor: NotifState.dnd ? Theme.accentText : Theme.accent
                    color: NotifState.dnd ? Theme.accent : hovered ? Theme.surfaceHover : "transparent"
                    text: "DND"
                    textColor: NotifState.dnd ? Theme.accentText : Theme.text
                    onClicked: NotifState.dnd = !NotifState.dnd
                }
                Block {
                    visible: NotifState.all.length > 0
                    hoverable: true
                    icon: ""
                    text: "Clear"
                    onClicked: NotifState.clearAll()
                }
            }
        }

        Item {
            id: body

            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
                margins: 14
                topMargin: 10
            }
            height: NotifState.all.length > 0 ? list.contentHeight : empty.implicitHeight

            Column {
                id: empty

                anchors.centerIn: parent
                visible: NotifState.all.length === 0
                topPadding: 24
                bottomPadding: 24
                spacing: 8

                Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: ""
                    color: Theme.subtext
                    font.pixelSize: 28
                }
                BarText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "All caught up"
                    color: Theme.subtext
                }
            }
        }

        ListView {
            id: list

            anchors {
                left: body.left
                right: body.right
                top: body.top
                bottom: parent.bottom
                bottomMargin: 14
            }
            clip: true
            spacing: 8
            boundsBehavior: Flickable.StopAtBounds
            // One entry per app, ordered by its newest notification
            model: ScriptModel {
                values: [...new Set(NotifState.all.map(n => n.appName).reverse())]
            }

            delegate: NotificationGroup {
                required property string modelData

                appName: modelData
                width: ListView.view.width
            }

            // No displaced transition: a group's height settles a frame after it's created, and an
            // in-flight y animation would leave the groups below stuck at the stale position
            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 150
                }
            }
        }
    }
}
