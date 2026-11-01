import QtQuick
import QtQuick.Effects

// The lock screen: the wallpaper and a password field
Item {
    id: root

    required property string username
    property string password
    property string message
    property bool messageIsError: false
    property bool busy: false
    property bool capsLock: false
    property bool primary: true

    readonly property string status: busy ? "Checking…" : [message, capsLock ? "Caps Lock is on" : ""].filter(part => part).join(" · ")

    signal edited(string text)
    signal submitted
    signal capsLockToggled

    Rectangle {
        anchors.fill: parent
        color: "#0d0e12"
    }

    Image {
        id: wallpaper

        anchors.fill: blurred
        visible: false
        source: Qt.resolvedUrl("wallpaper.jpg")
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        // Stretched by blurMultiplier below; a tiny source keeps that from showing artefacts
        sourceSize: Qt.size(160, 90)
    }

    MultiEffect {
        id: blurred

        // Blur fades out at its edges; keep that fade off screen
        anchors.fill: parent
        anchors.margins: -300
        source: wallpaper
        blurEnabled: true
        blur: 1
        blurMax: 64
        blurMultiplier: 3
    }

    Rectangle {
        id: field

        anchors.centerIn: parent
        width: 360
        height: 44
        radius: Theme.chipRadius
        color: Theme.bg
        // Transparent, not hidden: the compositor may give this monitor the keyboard,
        // and a hidden input couldn't take the typing
        opacity: root.primary ? 1 : 0
        border.width: 2
        border.color: root.messageIsError ? Theme.red : Theme.accent

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.anim
            }
        }

        TextInput {
            id: input

            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            verticalAlignment: TextInput.AlignVCenter
            clip: true
            text: root.password
            echoMode: TextInput.Password
            passwordCharacter: "•"
            readOnly: root.busy
            focus: true
            color: Theme.text
            selectionColor: Theme.accent
            font.family: Theme.fontFamily
            font.pixelSize: 15
            onTextEdited: root.edited(text)
            onAccepted: root.submitted()
            Keys.onEscapePressed: root.edited("")
            Keys.onReleased: event => {
                if (event.key === Qt.Key_CapsLock)
                    root.capsLockToggled();
            }

            // A lock surface can be mapped before it holds the keyboard
            Component.onCompleted: forceActiveFocus()

            Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: !input.text
                text: "Password for " + root.username
                color: Theme.subtext
                font: input.font
            }
        }
    }

    // Solid behind the text: it has to stay readable over any part of the wallpaper
    Rectangle {
        anchors.top: field.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: field.horizontalCenter
        visible: root.primary && root.status !== ""
        width: statusLabel.implicitWidth + 20
        height: Theme.barHeight
        radius: Theme.chipRadius
        color: Theme.bg

        Text {
            id: statusLabel

            anchors.centerIn: parent
            text: root.status
            color: root.messageIsError ? Theme.red : Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
