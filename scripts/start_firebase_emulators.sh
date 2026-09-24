#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
local_cli="$project_dir/.firebase-tools/node_modules/.bin/firebase"
export XDG_CONFIG_HOME="$project_dir/.firebase-tools/config"
export FIREBASE_EMULATORS_PATH="$project_dir/.firebase-tools/emulators"

if [[ -x "$project_dir/.firebase-tools/node/bin/node" ]]; then
  export PATH="$project_dir/.firebase-tools/node/bin:$PATH"
fi

if [[ -x "$local_cli" ]]; then
  firebase_cli="$local_cli"
elif command -v firebase >/dev/null 2>&1; then
  firebase_cli="$(command -v firebase)"
else
  echo "Falta Firebase CLI. Instálalo con npm install -g firebase-tools." >&2
  exit 1
fi

android_jdk="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
if [[ -z "${JAVA_HOME:-}" && -x "$android_jdk/bin/java" ]]; then
  export JAVA_HOME="$android_jdk"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

args=(
  emulators:start
  --only auth,firestore,storage,functions
  --project laboratorio-experience-app
  "--export-on-exit=$project_dir/emulator-data"
)
if [[ -d "$project_dir/emulator-data" ]]; then
  args+=("--import=$project_dir/emulator-data")
fi

cd "$project_dir"
exec "$firebase_cli" "${args[@]}"
