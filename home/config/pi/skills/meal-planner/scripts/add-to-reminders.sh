#!/usr/bin/env bash
set -euo pipefail

list_name="${1:-Groceries}"
shift || true

if (( $# == 0 )); then
  echo "Usage: $0 [list-name] item [item ...]" >&2
  exit 2
fi

osascript - "$list_name" "$@" <<'APPLESCRIPT'
on run argv
  set listName to item 1 of argv
  set itemNames to items 2 thru -1 of argv

  tell application "Reminders"
    if not (exists list listName) then error "Reminders list not found: " & listName
    set targetList to list listName
    repeat with itemName in itemNames
      make new reminder at end of reminders of targetList with properties {name:(itemName as text)}
    end repeat
  end tell

  return "Added " & (count of itemNames) & " item(s) to " & listName
end run
APPLESCRIPT
