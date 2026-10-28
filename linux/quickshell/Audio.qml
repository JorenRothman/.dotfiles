import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Block {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)

    hoverable: true
    icon: muted || volume < 34 ? "\uf026" : volume < 67 ? "\uf027" : "\uf028"
    iconColor: muted ? Theme.red : Theme.subtext
    text: muted ? "muted" : `${volume}%`
    textColor: muted ? Theme.subtext : Theme.text

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
