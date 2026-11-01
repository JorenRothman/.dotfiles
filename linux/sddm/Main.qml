import QtQuick
import QtQuick.Window

// SDDM's side of the lock screen's LoginScreen. Each monitor gets its own copy of this
// with no shared state, so typing on one can't appear on another.
Item {
    id: root

    readonly property bool hasPrimaryOutput: Qt.application.screens.some(screen => screen.name === "DP-1")
    // The keyboard can land on either monitor: the one holding it must show the field too
    readonly property bool showsField: Window.active || (hasPrimaryOutput ? Screen.name === "DP-1" : primaryScreen)
    // lastUser is empty until someone has logged in through SDDM. 257 is its NameRole.
    readonly property string username: userModel.lastUser || userModel.data(userModel.index(0, 0), 257) || ""

    width: Screen.width
    height: Screen.height

    LoginScreen {
        id: screen

        anchors.fill: parent
        username: root.username
        primary: root.showsField
        capsLock: keyboard.capsLock
        onEdited: text => {
            password = text;
            message = "";
            messageIsError = false;
        }
        onSubmitted: {
            if (busy || !password)
                return;
            busy = true;
            message = "";
            messageIsError = false;
            sddm.login(username, password, sessionModel.lastIndex);
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            screen.message = "Incorrect password";
            screen.messageIsError = true;
            screen.password = "";
            screen.busy = false;
        }
    }

    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.gap
        spacing: Theme.gap
        visible: root.showsField

        Repeater {
            model: [
                {
                    icon: "",
                    label: "Restart",
                    run: () => sddm.reboot()
                },
                {
                    icon: "",
                    label: "Shut down",
                    run: () => sddm.powerOff()
                }
            ]

            Rectangle {
                id: powerButton

                required property var modelData

                width: 32
                height: 32
                radius: Theme.chipRadius
                color: powerArea.containsMouse ? Theme.accent : Theme.bg

                Accessible.role: Accessible.Button
                Accessible.name: modelData.label

                Text {
                    anchors.centerIn: parent
                    text: powerButton.modelData.icon
                    color: powerArea.containsMouse ? Theme.accentText : Theme.subtext
                    font.family: Theme.iconFont
                    font.pixelSize: Theme.fontSize
                }

                MouseArea {
                    id: powerArea

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: powerButton.modelData.run()
                }
            }
        }
    }
}
