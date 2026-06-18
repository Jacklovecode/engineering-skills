#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HOOK_NAME="${1:-}"

if [ "$HOOK_NAME" = "session-start-codex" ]; then
  exec "$SCRIPT_DIR/session-start-codex.sh"
fi

exit 0
