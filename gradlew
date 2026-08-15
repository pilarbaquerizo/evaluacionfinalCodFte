#!/usr/bin/env sh
set -eu

APP_HOME="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DIST_URL="https://services.gradle.org/distributions/gradle-8.14.5-bin.zip"
GRADLE_VERSION="8.14.5"
CACHE_ROOT="${GRADLE_USER_HOME:-$HOME/.gradle}/wrapper/dists/gradle-$GRADLE_VERSION"
INSTALL_DIR="$CACHE_ROOT/gradle-$GRADLE_VERSION"
GRADLE_BIN="$INSTALL_DIR/bin/gradle"

if [ ! -x "$GRADLE_BIN" ]; then
  mkdir -p "$CACHE_ROOT"
  ZIP_FILE="$CACHE_ROOT/gradle-$GRADLE_VERSION-bin.zip"
  echo "Gradle $GRADLE_VERSION no está instalado localmente."
  echo "Descargando Gradle desde:"
  echo "$DIST_URL"
  echo
  if command -v curl >/dev/null 2>&1; then
    curl -fL "$DIST_URL" -o "$ZIP_FILE"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$ZIP_FILE" "$DIST_URL"
  else
    echo "ERROR: Se necesita curl o wget para descargar Gradle." >&2
    exit 1
  fi
  rm -rf "$INSTALL_DIR"
  unzip -q "$ZIP_FILE" -d "$CACHE_ROOT"
fi

if [ ! -x "$GRADLE_BIN" ]; then
  echo "ERROR: La instalación de Gradle no tiene la estructura esperada." >&2
  exit 1
fi

exec "$GRADLE_BIN" "$@"
