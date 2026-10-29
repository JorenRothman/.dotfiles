import QtQuick
import Quickshell
import Quickshell.Io

// Running containers; ddev ones are grouped by project
Block {
    id: root

    required property var window
    property var containers: []
    readonly property var projects: [...new Set(containers.map(c => c.match(/^ddev-(.+)-(web|db|phpmyadmin|mailpit|xhgui|redis|solr|memcached|elasticsearch)$/)?.[1]).filter(p => p))]
    readonly property var others: containers.filter(c => !c.startsWith("ddev-"))

    function run(command) {
        menu.open = false;
        Quickshell.execDetached(command);
    }

    visible: containers.length > 0
    hoverable: true
    color: menu.open || hovered ? Theme.surfaceHover : "transparent"
    icon: ""
    iconColor: Theme.accent
    text: containers.length
    onClicked: menu.open = !menu.open

    Process {
        id: ps
        command: ["docker", "ps", "--format", "{{.Names}}"]
        stdout: StdioCollector {
            onStreamFinished: root.containers = text.split("\n").filter(n => n).sort()
        }
        onExited: code => {
            if (code !== 0)
                root.containers = [];
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: ps.running = true
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window

        Repeater {
            model: root.projects

            MenuItem {
                required property string modelData

                icon: ""
                text: modelData
                detail: `${root.containers.filter(c => c.startsWith(`ddev-${modelData}-`)).length} svc`
                onClicked: root.run(["xdg-open", `https://${modelData}.ddev.site`])
            }
        }

        MenuSeparator {
            visible: root.projects.length > 0 && root.others.length > 0
        }

        // Anything else opens its logs
        Repeater {
            model: root.others

            MenuItem {
                required property string modelData

                icon: ""
                iconColor: Theme.subtext
                text: modelData
                onClicked: root.run(["ghostty", "-e", "docker", "logs", "-f", "--tail", "200", modelData])
            }
        }

        MenuSeparator {
            visible: root.projects.length > 0
        }

        MenuItem {
            visible: root.projects.length > 0
            icon: ""
            iconColor: Theme.red
            text: "Power off ddev"
            confirm: true
            onClicked: root.run(["ddev", "poweroff"])
        }
    }
}
