import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// Dropdown under the bar's center island
PanelWindow {
    id: root

    required property var bar

    visible: NotifState.centerOpen && NotifState.centerScreen === bar.screen.name
    anchors.top: true
    margins.top: Theme.gap
    exclusiveZone: 0
    implicitWidth: 420
    implicitHeight: panel.height
    color: "transparent"
    WlrLayershell.namespace: "quickshell-notifications"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // Clicking anywhere outside the panel or the bar closes it
    // Activated after the window maps; binding it to visible directly loops when the grab clears instantly
    onVisibleChanged: Qt.callLater(() => grab.active = root.visible)

    HyprlandFocusGrab {
        id: grab
        windows: [root, root.bar]
        onCleared: NotifState.centerOpen = false
    }

    Rectangle {
        id: panel

        width: parent.width
        height: Math.min(header.height + body.height + 24, (root.screen?.height ?? 1080) * 0.7)
        radius: Theme.radius
        color: Theme.bg
        border {
            width: 1
            color: Theme.outline
        }
        focus: true
        Keys.onEscapePressed: NotifState.centerOpen = false

        Item {
            id: header

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            height: Theme.chipHeight

            Row {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 4
                spacing: 7

                BarText {
                    text: "Notifications"
                    font.weight: Font.Bold
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
                    color: NotifState.dnd ? Theme.accent : hovered ? Theme.surface : "transparent"
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
                margins: 12
            }
            height: NotifState.all.length > 0 ? list.contentHeight : empty.implicitHeight

            Column {
                id: empty

                anchors.centerIn: parent
                visible: NotifState.all.length === 0
                topPadding: 24
                bottomPadding: 24
                spacing: 8

                BarText {
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
                bottomMargin: 12
            }
            clip: true
            spacing: 8
            boundsBehavior: Flickable.StopAtBounds
            model: ScriptModel {
                values: NotifState.all.map(n => n.id).reverse()
            }

            delegate: NotificationCard {
                required property int modelData

                nid: modelData
                width: ListView.view.width
            }

            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 150
                }
            }
            displaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
