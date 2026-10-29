#!/usr/bin/env python3
"""Print the next two weeks of Google Calendar events as JSON, read through gcalcli.

gcalcli holds the OAuth login; set it up once with `gcalcli --client-id=... --client-secret=... init`.
"""

import csv
import json
import subprocess
from datetime import date, timedelta

DAYS = 14


def main():
    start = date.today()
    end = start + timedelta(days=DAYS)
    try:
        result = subprocess.run(
            ["gcalcli", "--nocolor", "agenda", "--tsv", "--nodeclined",
             "--details", "url", "--details", "conference", str(start), str(end)],
            capture_output=True, text=True, timeout=30,
        )
    except FileNotFoundError:
        print(json.dumps({"error": "Install gcalcli and run gcalcli init"}))
        return
    if result.returncode != 0:
        print(json.dumps({"error": "gcalcli failed; run it in a terminal to check the login"}))
        return

    events = []
    for row in csv.DictReader(result.stdout.splitlines(), delimiter="\t"):
        all_day = not row["start_time"]
        events.append({
            "title": row["title"] or "(no title)",
            # Local times without an offset, which JS reads as local too
            "start": f"{row['start_date']}T{row['start_time'] or '00:00'}",
            "end": f"{row['end_date']}T{row['end_time'] or '00:00'}",
            "allDay": all_day,
            "link": row["hangout_link"] or (row["conference_uri"] if row["conference_entry_point_type"] == "video" else ""),
            "url": row["html_link"],
        })

    print(json.dumps({"events": events}))


if __name__ == "__main__":
    main()
