import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Block {
    id: root

    required property var window
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)
    readonly property string volumeIcon: muted || volume < 34 ? "" : volume < 67 ? "" : ""
    // Pipewire counts playback streams as sinks and recording streams as not; EasyEffects' own streams aren't apps
    readonly property var streams: Pipewire.nodes.values.filter(n => n.isStream && n.isSink && n.audio && !/^(ee_|easyeffects)/.test(n.name))
    // One row per app, however many streams it has open (browser tabs, games)
    readonly property var apps: {
        const groups = new Map();
        for (const node of streams) {
            const name = node.properties["application.name"] || node.nickname || node.name;
            if (!groups.has(name))
                groups.set(name, {
                    name,
                    icon: node.properties["application.icon-name"] || node.properties["application.process.binary"] || name.toLowerCase(),
                    nodes: []
                });
            groups.get(name).nodes.push(node);
        }
        return [...groups.values()].sort((a, b) => a.name.localeCompare(b.name));
    }

    hoverable: true
    color: menu.open || hovered ? Theme.surfaceHover : "transparent"
    icon: volumeIcon
    iconColor: muted ? Theme.red : Theme.subtext
    text: muted ? "muted" : `${volume}%`
    textColor: muted ? Theme.subtext : Theme.text

    onClicked: m => {
        if (m.button === Qt.LeftButton)
            menu.open = !menu.open;
        else if (m.button === Qt.RightButton && sink)
            sink.audio.muted = !sink.audio.muted;
    }
    onScrolled: w => {
        if (!sink)
            return;
        const step = w.angleDelta.y > 0 ? 0.03 : -0.03;
        sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + step));
    }

    // Pipewire nodes only expose audio properties while tracked
    PwObjectTracker {
        objects: [root.sink, ...root.streams]
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window
        menuWidth: 300

        VolumeRow {
            nodes: [root.sink]
            label: root.sink?.description || "Output"
            glyph: root.volumeIcon
        }

        MenuSeparator {}

        Repeater {
            model: root.apps

            VolumeRow {
                required property var modelData

                nodes: modelData.nodes
                label: modelData.name
                iconName: modelData.icon
            }
        }

        BarText {
            x: 10
            height: 32
            visible: root.apps.length === 0
            verticalAlignment: Text.AlignVCenter
            text: "No apps playing"
            color: Theme.subtext
        }

        MenuSeparator {}

        MenuItem {
            icon: ""
            iconColor: Theme.subtext
            text: "Sound settings"
            onClicked: {
                menu.open = false;
                Quickshell.execDetached(["pavucontrol"]);
            }
        }
    }
}
