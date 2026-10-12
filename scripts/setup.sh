#!/bin/bash
# Installs the HyperFrames toolchain: Node.js check, FFmpeg, HyperFrames CLI,
# Chrome Headless Shell (for rendering) and whisper.cpp (for transcription).
# Works on macOS (Homebrew) and Debian/Ubuntu Linux (apt + build from source).
set -euo pipefail

HF_VERSION="0.8.150"
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"

if [ "$(uname)" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install node ffmpeg whisper-cpp
else
  command -v node >/dev/null 2>&1 || { echo "Install Node.js >= 22 first"; exit 1; }
  if ! command -v ffmpeg >/dev/null 2>&1; then
    $SUDO apt-get update -qq && $SUDO apt-get install -y -qq ffmpeg
  fi
  if ! command -v whisper-cli >/dev/null 2>&1; then
    src="${WHISPER_SRC:-$HOME/.local/src/whisper.cpp}"
    rm -rf "$src" && git clone --depth 1 -q https://github.com/ggml-org/whisper.cpp "$src"
    cmake -S "$src" -B "$src/build" -DCMAKE_BUILD_TYPE=Release \
      -DWHISPER_BUILD_TESTS=OFF -DBUILD_SHARED_LIBS=OFF >/dev/null
    cmake --build "$src/build" -j"$(nproc)" --config Release --target whisper-cli >/dev/null
    $SUDO install -m755 "$src/build/bin/whisper-cli" /usr/local/bin/whisper-cli
  fi
fi

node_major=$(node -p 'process.versions.node.split(".")[0]')
[ "$node_major" -ge 22 ] || { echo "HyperFrames needs Node.js >= 22 (found $(node -v))"; exit 1; }

npm install -g "hyperframes@$HF_VERSION"
hyperframes browser ensure
hyperframes doctor || true
