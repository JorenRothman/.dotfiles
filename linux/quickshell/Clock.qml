import QtQuick
import Quickshell

Block {
    hoverable: true
    text: Qt.formatDateTime(clock.date, "HH:mm")
    detail: Qt.formatDateTime(clock.date, "ddd dd MMM")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
