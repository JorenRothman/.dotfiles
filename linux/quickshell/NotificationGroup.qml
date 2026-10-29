import QtQuick
import Quickshell

// Every notification from one app; with more than one, collapses to the newest behind a header
Column {
    id: root

    required property string appName
    readonly property bool expanded: NotifState.expandedApps[appName] ?? false
    readonly property var ids: NotifState.all.filter(n => n.appName === appName).map(n => n.id).reverse()
    readonly property bool grouped: ids.length > 1

    spacing: 6

    Item {
        width: parent.width
        height: Theme.chipHeight
        visible: root.grouped

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: NotifState.expandedApps = Object.assign({}, NotifState.expandedApps, {
                [root.appName]: !root.expanded
            })
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 4
            spacing: 7

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                width: 12
                text: root.expanded ? "" : ""
                color: Theme.subtext
                font.pixelSize: 10
            }
            BarText {
                text: root.appName || "Other"
                font.weight: Font.DemiBold
            }
            BarText {
                text: root.ids.length
                color: Theme.subtext
            }
        }

        Block {
            anchors.right: parent.right
            hoverable: true
            icon: ""
            onClicked: NotifState.dismissApp(root.appName)
        }
    }

    Repeater {
        model: ScriptModel {
            values: root.expanded ? root.ids : root.ids.slice(0, 1)
        }

        NotificationCard {
            required property int modelData

            nid: modelData
            width: root.width
        }
    }
}
