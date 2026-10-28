import QtQuick
import Quickshell

Block {
    hoverable: true
    bottomLeftRadius: Theme.radius
    text: Qt.formatDateTime(clock.date, "dd-MM HH:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
