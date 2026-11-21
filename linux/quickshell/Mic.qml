import QtQuick
import Quickshell.Services.Pipewire

// Mic mute indicator; only shown while the default source is muted, click to unmute
Block {
    id: root

    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool muted: source?.audio?.muted ?? false

    visible: muted
    hoverable: true
    icon: String.fromCodePoint(0xf036d) // nf-md-microphone_off
    iconColor: Theme.red
    text: "muted"
    textColor: Theme.subtext

    onClicked: {
        if (source)
            source.audio.muted = !source.audio.muted;
    }

    // Pipewire nodes only expose audio properties while tracked
    PwObjectTracker {
        objects: [root.source]
    }
}
