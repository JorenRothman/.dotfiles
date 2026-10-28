import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Block {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)
    readonly property string icon: volume < 34 ? "" : volume < 67 ? "" : ""

    hoverable: true
    separator: false
    bottomRightRadius: Theme.radius
    text: muted ? " muted" : `${icon} ${volume}%`

    onClicked: m => {
        if (m.button === Qt.LeftButton)
            Quickshell.execDetached(["pavucontrol"]);
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
        objects: [root.sink]
    }
}
