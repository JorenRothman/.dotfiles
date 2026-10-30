import QtQuick
import Quickshell.Services.Mpris
import Quickshell.Widgets

// Current MPRIS player: track in the bar, art and controls in a dropdown
Block {
    id: root

    required property var window
    // playerctld only mirrors the other players; browsers would surface every tab with a video
    readonly property var players: Mpris.players.values.filter(p => !/^org\.mpris\.MediaPlayer2\.(playerctld|brave|chromium|chrome|google-chrome|firefox|librewolf|zen|vivaldi|edge|msedge|opera)\b/.test(p.dbusName))
    readonly property var playing: players.find(p => p.isPlaying) ?? null
    // Stays on the last player used when everything is paused
    property var last: null
    readonly property var player: playing ?? (players.includes(last) ? last : players[0] ?? null)
    readonly property string title: player?.trackTitle ?? ""
    readonly property bool hasLength: (player?.lengthSupported ?? false) && player.length > 0

    function clock(seconds) {
        const s = Math.max(0, Math.floor(seconds));
        const m = Math.floor(s / 60);
        const pad = n => String(n).padStart(2, "0");
        return m >= 60 ? `${Math.floor(m / 60)}:${pad(m % 60)}:${pad(s % 60)}` : `${m}:${pad(s % 60)}`;
    }

    onPlayingChanged: {
        if (playing)
            last = playing;
    }

    visible: title !== ""
    hoverable: true
    color: menu.open || hovered ? Theme.surfaceHover : "transparent"
    icon: player?.isPlaying ? "" : ""
    iconColor: player?.isPlaying ? Theme.accent : Theme.subtext
    text: title.length > 32 ? `${title.slice(0, 31)}…` : title
    textColor: player?.isPlaying ? Theme.text : Theme.subtext

    onClicked: m => {
        if (m.button === Qt.LeftButton)
            menu.open = !menu.open;
        else if (m.button === Qt.RightButton && player?.canTogglePlaying)
            player.togglePlaying();
    }

    component Control: Rectangle {
        id: control

        property string icon

        signal clicked

        width: 32
        height: 32
        radius: Theme.chipRadius
        color: area.containsMouse ? Theme.surfaceHover : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Theme.anim
            }
        }

        Icon {
            anchors.centerIn: parent
            text: control.icon
            color: control.enabled ? Theme.text : Theme.subtext
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: control.clicked()
        }
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window
        menuWidth: 280

        // Position isn't pushed by MPRIS; it only refreshes when this signal fires
        Timer {
            interval: 1000
            running: menu.open
            repeat: true
            triggeredOnStart: true
            onTriggered: root.player?.positionChanged()
        }

        Item {
            width: parent.width
            height: 76

            ClippingRectangle {
                id: art

                x: 6
                y: 6
                width: 64
                height: 64
                radius: Theme.cardRadius
                color: Theme.surface

                Image {
                    id: cover
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    sourceSize: Qt.size(128, 128)
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }

                Icon {
                    anchors.centerIn: parent
                    visible: cover.status !== Image.Ready
                    text: ""
                    color: Theme.accent
                    font.pixelSize: 20
                }
            }

            Column {
                anchors {
                    left: art.right
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 6
                    verticalCenter: art.verticalCenter
                }
                spacing: 2

                BarText {
                    width: parent.width
                    text: root.title
                    elide: Text.ElideRight
                }
                BarText {
                    width: parent.width
                    visible: text !== ""
                    text: root.player?.trackArtist ?? ""
                    color: Theme.subtext
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                }
                BarText {
                    width: parent.width
                    text: root.player?.identity ?? ""
                    color: Theme.subtext
                    font.weight: Font.Normal
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }
        }

        // Progress; the taller hit area makes the thin track easy to click
        Item {
            width: parent.width
            height: 28
            visible: root.hasLength

            Rectangle {
                id: track

                x: 6
                y: 4
                width: parent.width - 12
                height: 4
                radius: 2
                color: Theme.surface

                Rectangle {
                    height: parent.height
                    radius: parent.radius
                    color: Theme.accent
                    width: root.hasLength ? parent.width * Math.min(1, root.player.position / root.player.length) : 0
                }
            }

            MouseArea {
                x: track.x
                width: track.width
                height: 12
                enabled: root.player?.canSeek ?? false
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: m => root.player.position = m.x / width * root.player.length
            }

            BarText {
                x: 6
                y: 12
                text: root.clock(root.player?.position ?? 0)
                color: Theme.subtext
                font.pixelSize: 12
            }
            BarText {
                anchors.right: parent.right
                anchors.rightMargin: 6
                y: 12
                text: root.clock(root.player?.length ?? 0)
                color: Theme.subtext
                font.pixelSize: 12
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4

            Control {
                icon: ""
                enabled: root.player?.canGoPrevious ?? false
                onClicked: root.player.previous()
            }
            Control {
                icon: root.player?.isPlaying ? "" : ""
                enabled: root.player?.canTogglePlaying ?? false
                onClicked: root.player.togglePlaying()
            }
            Control {
                icon: ""
                enabled: root.player?.canGoNext ?? false
                onClicked: root.player.next()
            }
        }
    }
}
