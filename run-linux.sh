#!/usr/bin/env bash
set -euo pipefail
preset="${1:-debug}"
[[ "$preset" == debug || "$preset" == release ]] || { echo "Usage: $0 [debug|release] [den-shell|den-broker-service|den-compositor] [args...]" >&2; exit 2; }
shift || true
component="${1:-den-shell}"
[[ $# -eq 0 ]] || shift
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
build_dir="$script_dir/build-ninja/$preset/den-desktop-builder"
case "$component" in
    den-shell) binary="$build_dir/den-shell/den-shell" ;;
    den-broker-service) binary="$build_dir/den-broker-service/service/den-broker-service" ;;
    den-compositor) binary="$build_dir/den-compositor/den-compositor" ;;
    *) echo "Unknown Den component: $component" >&2; exit 2 ;;
esac
[[ -x "$binary" ]] || { echo "Build first with $script_dir/build-linux.sh $preset" >&2; exit 1; }
if [[ "$component" == den-shell ]] && command -v dbus-run-session >/dev/null 2>&1; then
    exec dbus-run-session -- "$binary" "$@"
fi
exec "$binary" "$@"
