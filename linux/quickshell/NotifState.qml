pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    // Every notification stays tracked (and listed in the center) until dismissed; popups are a subset
    readonly property var all: server.trackedNotifications.values
    readonly property alias popups: popupModel
    property bool dnd: false
    property bool centerOpen: false
    property string centerScreen: ""
    // Popups show on the monitor focused when the first of a batch arrived, so visible ones don't jump screens
    property string popupScreen: ""

    function find(id) {
        return all.find(n => n.id === id) ?? null;
    }

    function hidePopup(id) {
        for (let i = 0; i < popupModel.count; i++) {
            if (popupModel.get(i).nid === id) {
                popupModel.remove(i);
                return;
            }
        }
    }

    // Transient notifications aren't meant to be kept around after their popup
    function popupTimedOut(id) {
        const n = find(id);
        if (n?.transient)
            n.expire();
        hidePopup(id);
    }

    function clearAll() {
        for (const n of [...all])
            n.dismiss();
    }

    function toggleCenter(screenName) {
        centerScreen = screenName;
        centerOpen = !centerOpen;
        if (centerOpen)
            popupModel.clear();
    }

    ListModel {
        id: popupModel
    }

    // e.g. `qs ipc call notifications toggle` from a Hyprland bind
    IpcHandler {
        target: "notifications"

        function toggle(): void {
            root.toggleCenter(HyprState.focusedMonitor);
        }
        function clear(): void {
            root.clearAll();
        }
        function toggleDnd(): void {
            root.dnd = !root.dnd;
        }
    }

    NotificationServer {
        id: server

        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;
            const id = n.id;
            n.closed.connect(() => root.hidePopup(id));
            const critical = n.urgency === NotificationUrgency.Critical;
            if (root.centerOpen || (root.dnd && !critical))
                return;
            if (popupModel.count === 0)
                root.popupScreen = HyprState.focusedMonitor;
            popupModel.insert(0, { nid: id });
        }
    }
}
