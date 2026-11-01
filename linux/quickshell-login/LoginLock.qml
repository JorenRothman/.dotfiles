import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Covers every output with a LoginScreen, sharing the typed password between them
WlSessionLock {
    id: root

    required property string username
    property string password
    property string message
    property bool messageIsError: false
    property bool busy: false
    property bool capsLock: false

    // Falls back to any connected screen: a lock with no field anywhere can't be used
    readonly property string primaryScreen: Quickshell.screens.some(screen => screen.name === "DP-1") ? "DP-1" : Quickshell.screens[0]?.name ?? ""

    signal submitted

    function fail(text) {
        message = text;
        messageIsError = true;
        password = "";
        busy = false;
    }

    locked: true

    readonly property Process capsLockQuery: Process {
        running: true
        command: ["hyprctl", "devices", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.capsLock = JSON.parse(text).keyboards.some(keyboard => keyboard.main && keyboard.capsLock);
                } catch (e) {
                    root.capsLock = false;
                }
            }
        }
    }

    WlSessionLockSurface {
        id: surface

        LoginScreen {
            anchors.fill: parent
            primary: !surface.screen || surface.screen.name === root.primaryScreen
            username: root.username
            password: root.password
            message: root.message
            messageIsError: root.messageIsError
            busy: root.busy
            capsLock: root.capsLock
            onEdited: text => {
                root.password = text;
                root.message = "";
                root.messageIsError = false;
            }
            onSubmitted: root.submitted()
            onCapsLockToggled: root.capsLockQuery.running = true
        }
    }
}
