pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Quickshell 0.3.2's Hyprland module leaves workspaces/monitors empty under Hyprland's Lua config,
// so read them from hyprctl and refresh on event socket updates instead
Singleton {
    id: root

    property var workspaces: []
    property var activeByMonitor: ({})
    property string focusedMonitor: ""
    property string submap: ""

    function activate(name) {
        Quickshell.execDetached(["hyprctl", "dispatch", `hl.dsp.focus({ workspace = "name:${name}" })`]);
    }

    Process {
        id: workspacesProc
        command: ["hyprctl", "-j", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.workspaces = JSON.parse(text)
        }
    }

    Process {
        id: monitorsProc
        command: ["hyprctl", "-j", "monitors"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const active = {};
                for (const m of JSON.parse(text)) {
                    active[m.name] = m.activeWorkspace.name;
                    if (m.focused)
                        root.focusedMonitor = m.name;
                }
                root.activeByMonitor = active;
            }
        }
    }

    // Events arrive in bursts, coalesce them into one refresh
    Timer {
        id: refresh
        interval: 50
        onTriggered: {
            workspacesProc.running = true;
            monitorsProc.running = true;
        }
    }

    Socket {
        path: `${Quickshell.env("XDG_RUNTIME_DIR")}/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`
        connected: true
        parser: SplitParser {
            onRead: line => {
                const sep = line.indexOf(">>");
                const event = line.slice(0, sep);
                if (event === "submap")
                    root.submap = line.slice(sep + 2);
                else if (/workspace|mon|special/.test(event))
                    refresh.restart();
            }
        }
    }
}
