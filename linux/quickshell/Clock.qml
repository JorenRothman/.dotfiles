import QtQuick
import Quickshell
import Quickshell.Io

// Time and date; the next meeting takes the date's place when it's close. Click for a calendar.
Block {
    id: root

    required property var window
    property var events: []
    property string error: ""
    property date viewMonth: new Date()

    readonly property date now: clock.date
    // Timed events still running or starting within the hour
    readonly property var soon: events.find(e => !e.allDay && e.end > now && e.start - now < 3600000)
    // Today and tomorrow only; the grid's dots cover further ahead
    readonly property var upcoming: events.filter(e => e.end > now && e.start < new Date(now.getFullYear(), now.getMonth(), now.getDate() + 2))
    readonly property var busyDays: new Set(events.map(e => key(e.start)))

    function key(d) {
        return `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`;
    }

    function label(d) {
        const days = Math.round((new Date(d).setHours(0, 0, 0, 0) - new Date(now).setHours(0, 0, 0, 0)) / 86400000);
        return days === 0 ? "Today" : days === 1 ? "Tomorrow" : Qt.formatDate(d, "dddd d MMM");
    }

    function shorten(text, length) {
        return text.length > length ? text.slice(0, length - 1) + "…" : text;
    }

    function open(event) {
        menu.open = false;
        const d = event.start;
        Quickshell.execDetached(["xdg-open", event.link || event.url || `https://calendar.google.com/calendar/r/day/${d.getFullYear()}/${d.getMonth() + 1}/${d.getDate()}`]);
    }

    hoverable: true
    color: menu.open || hovered ? Theme.surfaceHover : "transparent"
    text: Qt.formatDateTime(now, "HH:mm")
    detail: soon ? `${soon.start <= now ? "now" : `in ${Math.ceil((soon.start - now) / 60000)}m`} · ${shorten(soon.title, 28)}` : Qt.formatDateTime(now, "ddd dd MMM")
    detailColor: soon ? Theme.accent : Theme.subtext
    onClicked: {
        viewMonth = new Date();
        menu.open = !menu.open;
        if (menu.open)
            fetch.running = true;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Process {
        id: fetch
        command: ["python3", Quickshell.shellDir + "/scripts/calendar.py"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const result = JSON.parse(text);
                    root.error = result.error ?? "";
                    if (result.events)
                        root.events = result.events.map(e => Object.assign({}, e, {
                            start: new Date(e.start),
                            end: new Date(e.end)
                        }));
                } catch (e) {
                    root.error = "Couldn't read the calendar";
                }
            }
        }
    }

    Timer {
        interval: 5 * 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetch.running = true
    }

    DropdownMenu {
        id: menu

        target: root
        bar: root.window
        menuWidth: 300

        // Month header with paging
        Item {
            width: parent.width
            height: 32

            BarText {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text: Qt.formatDate(root.viewMonth, "MMMM yyyy")
                font.weight: Font.DemiBold
            }

            Row {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                Repeater {
                    model: [-1, 1]

                    Rectangle {
                        required property int modelData

                        width: 28
                        height: 28
                        radius: Theme.chipRadius
                        color: page.containsMouse ? Theme.surfaceHover : "transparent"

                        Icon {
                            anchors.centerIn: parent
                            text: parent.modelData < 0 ? "" : ""
                            color: Theme.subtext
                            font.pixelSize: 11
                        }

                        MouseArea {
                            id: page
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.viewMonth = new Date(root.viewMonth.getFullYear(), root.viewMonth.getMonth() + parent.modelData, 1)
                        }
                    }
                }
            }
        }

        // Month grid, weeks starting on Monday; a dot marks days with events
        Grid {
            id: grid

            readonly property date first: new Date(root.viewMonth.getFullYear(), root.viewMonth.getMonth(), 1)
            readonly property int offset: (first.getDay() + 6) % 7
            readonly property int length: new Date(first.getFullYear(), first.getMonth() + 1, 0).getDate()
            readonly property real cell: width / 7

            width: parent.width
            columns: 7

            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

                BarText {
                    required property string modelData

                    width: grid.cell
                    height: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: modelData
                    color: Theme.subtext
                    font.pixelSize: 11
                }
            }

            Repeater {
                model: Math.ceil((grid.offset + grid.length) / 7) * 7

                Item {
                    id: day

                    required property int index
                    readonly property date date: new Date(grid.first.getFullYear(), grid.first.getMonth(), index - grid.offset + 1)
                    readonly property bool inMonth: date.getMonth() === grid.first.getMonth()
                    readonly property bool today: root.key(date) === root.key(root.now)

                    width: grid.cell
                    height: 30

                    Rectangle {
                        anchors.centerIn: parent
                        width: 26
                        height: 26
                        radius: Theme.chipRadius
                        color: day.today ? Theme.accent : "transparent"
                    }

                    BarText {
                        anchors.centerIn: parent
                        text: day.date.getDate()
                        color: day.today ? Theme.accentText : day.inMonth ? Theme.text : Theme.outline
                        font.weight: day.today ? Font.DemiBold : Font.Normal
                    }

                    Rectangle {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 3
                        }
                        visible: !day.today && root.busyDays.has(root.key(day.date))
                        width: 3
                        height: 3
                        radius: 1.5
                        color: Theme.accent
                    }
                }
            }
        }

        MenuSeparator {}

        BarText {
            visible: root.error !== ""
            x: 10
            width: parent.width - 20
            topPadding: 4
            bottomPadding: 4
            text: root.error
            color: Theme.subtext
            wrapMode: Text.Wrap
        }

        BarText {
            visible: root.error === "" && root.upcoming.length === 0
            width: parent.width
            height: 32
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Nothing today or tomorrow"
            color: Theme.subtext
        }

        // Upcoming events grouped by day; clicking joins the call or opens the day
        Repeater {
            model: [...new Set(root.upcoming.slice(0, 10).map(e => root.key(e.start)))]

            Column {
                id: section

                required property string modelData
                readonly property var items: root.upcoming.slice(0, 10).filter(e => root.key(e.start) === modelData)

                width: parent.width

                BarText {
                    x: 10
                    height: 26
                    verticalAlignment: Text.AlignBottom
                    bottomPadding: 4
                    text: root.label(section.items[0].start)
                    color: Theme.subtext
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                }

                Repeater {
                    model: section.items

                    MenuItem {
                        required property var modelData

                        icon: modelData.link ? "" : ""
                        iconColor: modelData.start <= root.now && modelData.end > root.now ? Theme.accent : Theme.subtext
                        text: modelData.title
                        detail: modelData.allDay ? "all day" : `${Qt.formatTime(modelData.start, "HH:mm")}–${Qt.formatTime(modelData.end, "HH:mm")}`
                        onClicked: root.open(modelData)
                    }
                }
            }
        }
    }
}
