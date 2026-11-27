#!/usr/bin/env bash
# Compila el clon y relanza Nebula Music. Uso: dev-reload.sh [BUILD_DIR]
set -euo pipefail

source_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="${1:-$source_root/build/dev}"
binary="$build_dir/orchard"

[[ -x "$binary" || -f "$build_dir/build.ninja" ]] || {
  echo "No hay build en $build_dir" >&2
  exit 1
}

ninja -C "$build_dir"

pkill -f -- "$binary" 2>/dev/null || true
for _ in $(seq 1 40); do
  pgrep -f -- "$binary" >/dev/null || break
  sleep 0.25
done

log="${TMPDIR:-/tmp}/nebula-music-dev.log"
nohup env QT_QPA_PLATFORM=xcb "$binary" >"$log" 2>&1 &
echo "Nebula Music arriba (log: $log)"
