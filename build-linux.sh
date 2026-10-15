#!/usr/bin/env bash
set -euo pipefail
usage() { echo "Usage: $0 [debug|release]"; }
preset="${1:-debug}"
case "$preset" in debug|release) ;; -h|--help) usage; exit 0 ;; *) usage >&2; exit 2 ;; esac
[[ "$(uname -s)" == Linux ]] || { echo "This build script requires Linux." >&2; exit 1; }
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
for tool in cmake ninja; do command -v "$tool" >/dev/null || { echo "Missing dependency: $tool" >&2; exit 1; }; done
cmake --preset "$preset" -S "$script_dir"
cmake --build --preset "$preset" --parallel "${BUILD_JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)}"
echo "Den Desktop Linux build is in $script_dir/build-ninja/$preset"
