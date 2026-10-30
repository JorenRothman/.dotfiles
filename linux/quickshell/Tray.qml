import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Block {
    id: root

    required property var window
    // nm-applet keeps running as the Wi-Fi password prompt, but Network.qml replaces its icon
    readonly property var items: SystemTray.items.values.filter(i => i.id !== "nm-applet")

    visible: items.length > 0

    Repeater {
        model: root.items

        IconImage {
            id: icon

            required property SystemTrayItem modelData

            implicitSize: 16
            anchors.verticalCenter: parent.verticalCenter
            source: modelData.icon

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: m => {
                    const item = icon.modelData;
                    if (m.button === Qt.LeftButton && !item.onlyMenu) {
                        item.activate();
                    } else if (m.button === Qt.MiddleButton) {
                        item.secondaryActivate();
                    } else if (item.hasMenu) {
                        const p = icon.mapToItem(null, 0, icon.height);
                        item.display(root.window, p.x, p.y + 4);
                    }
                }
            }
        }
    }
}
