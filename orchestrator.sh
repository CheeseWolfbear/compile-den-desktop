#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 2 ]] || { echo "Usage: $0 {aarch64|x86_64} RUNTIME_DIR" >&2; exit 2; }
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
"$script_dir/../compile-apk/orchestrator.sh" compile-project "$1" "$2" paw-kit-apps
exec "$script_dir/../compile-apk/orchestrator.sh" compile-project "$1" "$2" den-desktop
