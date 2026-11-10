#!/usr/bin/env bash
set -euo pipefail

# Replaced by Nix module with the actual path
FIREJAIL_PROFILE="@PROFILE@"
CLAUDE_BINARY="@CLAUDE@"

HOME="$(realpath "$HOME")"
export HOME

PROJECT="$(pwd -P)"

if [[ "$PROJECT" == "/" || "$PROJECT" == "$HOME" ]]; then
    echo "Refusing to run Claude from / or HOME." >&2
    exit 1
fi

FIREJAIL="$(command -v firejail)"
if [[ -x /run/wrappers/bin/firejail ]]; then
    FIREJAIL=/run/wrappers/bin/firejail
fi

HM_PROFILE="$(readlink -e "/etc/profiles/per-user/$USER")"
export PATH="$HM_PROFILE/bin:$PATH"

exec "$FIREJAIL" \
    --profile="$FIREJAIL_PROFILE" \
    --whitelist="$PROJECT" \
    -- \
    "$CLAUDE_BINARY" "$@"
