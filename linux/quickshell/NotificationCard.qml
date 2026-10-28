import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Rectangle {
    id: root

    required property int nid
    property bool popup: false
    readonly property Notification notif: NotifState.find(nid)

    // Bound directly so the card has its final height when the list positions it;
    // frozen on close so it can still animate out after the object is destroyed
    property string appName: notif?.appName ?? ""
    property string summary: notif?.summary ?? ""
    property string body: notif?.body ?? ""
    property string iconSource: notif ? source(notif.image) || source(notif.appIcon) : ""
    property bool critical: notif?.urgency === NotificationUrgency.Critical
    property var actions: notif?.actions ?? []
    property real timeout: critical ? 0 : (notif?.expireTimeout ?? 0) > 0 ? notif.expireTimeout : 6000

    signal timedOut

    function source(path) {
        if (path === "")
            return "";
        if (path.startsWith("/"))
            return "file://" + path;
        if (path.includes("://"))
            return path;
        return Quickshell.iconPath(path, true);
    }

    implicitWidth: 380
    implicitHeight: content.implicitHeight + 24
    radius: Theme.radius
    color: popup ? Theme.bg : hover.hovered ? Theme.surface : Theme.card
    border {
        width: 1
        color: critical ? Theme.accent : Theme.outline
    }

    Behavior on color {
        ColorAnimation {
            duration: Theme.anim
        }
    }

    Connections {
        target: root.notif

        // A replacement notification reuses the object; give it a fresh countdown
        function onSummaryChanged() {
            if (countdown.running)
                countdown.restart();
        }
        function onClosed() {
            // Self-assignment breaks the bindings, keeping the last values
            root.appName = root.appName;
            root.summary = root.summary;
            root.body = root.body;
            root.iconSource = root.iconSource;
            root.critical = root.critical;
            root.actions = [];
            root.timeout = root.timeout;
        }
    }

    // Popups slide in from the screen edge, and out before being hidden
    function slideOut(then) {
        exit.then = then;
        exit.start();
    }

    ParallelAnimation {
        running: root.popup

        NumberAnimation {
            target: root
            property: "x"
            from: 400
            to: 0
            duration: 250
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }
    }

    ParallelAnimation {
        id: exit

        property var then

        onFinished: then()

        NumberAnimation {
            target: root
            property: "x"
            to: 400
            duration: 200
            easing.type: Easing.InCubic
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: 200
        }
    }

    HoverHandler {
        id: hover
    }

    // Left click runs the default action (which also dismisses), middle click dismisses
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: m => {
            const action = root.actions.find(a => a?.identifier === "default");
            if (m.button === Qt.MiddleButton)
                root.notif?.dismiss();
            else if (action)
                action.invoke();
            else if (root.popup)
                root.slideOut(() => NotifState.hidePopup(root.nid));
        }
    }

    Row {
        id: content

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 12

        Rectangle {
            width: 40
            height: 40
            radius: Theme.chipRadius
            color: Theme.surface

            ClippingRectangle {
                anchors.fill: parent
                radius: Theme.chipRadius
                color: "transparent"
                visible: icon.status === Image.Ready

                Image {
                    id: icon
                    anchors.fill: parent
                    source: root.iconSource
                    sourceSize: Qt.size(80, 80)
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }

            BarText {
                anchors.centerIn: parent
                visible: icon.status !== Image.Ready
                text: ""
                color: Theme.accent
                font.pixelSize: 16
            }
        }

        Column {
            width: content.width - 40 - content.spacing
            spacing: 2

            Item {
                width: parent.width
                height: app.implicitHeight

                BarText {
                    id: app
                    anchors {
                        left: parent.left
                        right: close.left
                        rightMargin: 8
                    }
                    text: root.appName
                    color: Theme.subtext
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }

                BarText {
                    id: close
                    anchors.right: parent.right
                    opacity: hover.hovered ? 1 : 0
                    text: ""
                    color: closeArea.containsMouse ? Theme.accent : Theme.subtext
                    font.pixelSize: 12

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.anim
                        }
                    }

                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.notif?.dismiss()
                    }
                }
            }

            BarText {
                width: parent.width
                text: root.summary
                font.weight: Font.Bold
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            BarText {
                width: parent.width
                visible: root.body !== ""
                text: root.body
                textFormat: Text.StyledText
                color: Theme.subtext
                font.pixelSize: 12
                wrapMode: Text.Wrap
                maximumLineCount: root.popup ? 3 : 6
                elide: Text.ElideRight
                onLinkActivated: link => Qt.openUrlExternally(link)
            }

            Flow {
                width: parent.width
                topPadding: 6
                spacing: 6
                visible: buttons.count > 0

                Repeater {
                    id: buttons

                    model: root.actions.filter(a => a && a.identifier !== "default")

                    Rectangle {
                        required property NotificationAction modelData

                        implicitWidth: label.implicitWidth + 20
                        implicitHeight: 24
                        radius: Theme.chipRadius
                        color: actionArea.containsMouse ? Theme.accent : Theme.surface

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.anim
                            }
                        }

                        BarText {
                            id: label
                            anchors.centerIn: parent
                            text: parent.modelData?.text ?? ""
                            color: actionArea.containsMouse ? Theme.accentText : Theme.text
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: actionArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: parent.modelData?.invoke()
                        }
                    }
                }
            }
        }
    }

    // Time left before the popup slides away, paused while hovered
    Rectangle {
        id: progress

        visible: root.popup && root.timeout > 0
        anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 1
            leftMargin: Theme.radius
        }
        height: 2
        radius: 1
        color: Theme.accent
        opacity: 0.6

        NumberAnimation on width {
            id: countdown
            from: root.width - Theme.radius * 2
            to: 0
            duration: root.timeout
            running: root.popup && root.timeout > 0
            paused: running && hover.hovered
            onFinished: root.slideOut(() => root.timedOut())
        }
    }
}
