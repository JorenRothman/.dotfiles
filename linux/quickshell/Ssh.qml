import QtQuick
import Quickshell
import Quickshell.Io

// Hosts from the SSH config; picking one opens a session in a new terminal
Block {
    id: root

    required property var window
    property var hosts: []
    property string query: ""
    property int selectedIndex: 0
    readonly property var matches: hosts.filter(h => `${h.alias} ${h.hostname}`.toLowerCase().includes(query.toLowerCase()))

    function connect(host) {
        menu.open = false;
        Quickshell.execDetached(["ghostty", "-e", "ssh", host.alias]);
    }

    hoverable: true
    color: menu.open || hovered ? Theme.surfaceHover : "transparent"
    icon: ""
    text: "SSH"
    onClicked: {
        menu.open = !menu.open;
        if (!menu.open)
            return;
        query = "";
        selectedIndex = 0;
        read.running = true;
        // The menu has to be mapped before its input can take keyboard focus
        Qt.callLater(() => search.forceActiveFocus());
    }
    onQueryChanged: selectedIndex = 0

    // Concrete aliases only; wildcard patterns just carry shared options
    Process {
        id: read
        running: true
        command: ["sh", "-c", "cat ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                const hosts = [];
                let current = [];
                for (const line of text.split("\n")) {
                    const [key, ...values] = line.trim().split(/\s+/);
                    if (/^host$/i.test(key)) {
                        current = values.filter(v => !/[*?!]/.test(v)).map(alias => ({ alias, hostname: "" }));
                        hosts.push(...current);
                    } else if (/^hostname$/i.test(key)) {
                        for (const host of current)
                            host.hostname = values[0];
                    }
                }
                root.hosts = hosts;
            }
        }
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window
        menuWidth: 320
        keyboard: true

        // Type to filter, arrows to move, enter to connect
        Item {
            width: parent.width
            height: 34

            Icon {
                id: searchIcon
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                width: 16
                horizontalAlignment: Text.AlignHCenter
                text: ""
                color: Theme.subtext
            }

            TextInput {
                id: search
                anchors {
                    left: searchIcon.right
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: root.query
                onTextEdited: root.query = text
                color: Theme.text
                selectionColor: Theme.accent
                selectedTextColor: Theme.accentText
                font {
                    family: Theme.fontFamily
                    pixelSize: Theme.fontSize
                }
                clip: true

                Keys.onEscapePressed: menu.open = false
                Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                Keys.onDownPressed: root.selectedIndex = Math.min(root.matches.length - 1, root.selectedIndex + 1)
                Keys.onReturnPressed: if (root.matches.length > 0) root.connect(root.matches[root.selectedIndex])

                BarText {
                    visible: search.text === ""
                    text: "Search hosts"
                    color: Theme.subtext
                    font.weight: Font.Normal
                }
            }
        }

        MenuSeparator {}

        Repeater {
            model: root.matches

            MenuItem {
                required property var modelData
                required property int index

                icon: ""
                text: modelData.alias
                detail: modelData.hostname
                selected: index === root.selectedIndex
                onClicked: root.connect(modelData)
            }
        }

        BarText {
            visible: root.matches.length === 0
            width: parent.width
            height: 32
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "No matching hosts"
            color: Theme.subtext
        }
    }
}
