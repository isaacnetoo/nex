# nex

Video editing with [HyperFrames](https://github.com/heygen-com/hyperframes): you write HTML compositions and render them to MP4.

## Setup

```bash
./scripts/setup.sh
```

This script installs the following:

| Tool | Purpose | macOS | Linux |
| --- | --- | --- | --- |
| Homebrew | Package manager | installed if missing | not used |
| Node.js ≥ 22 | Runs the HyperFrames CLI | `brew install node` | must already be installed |
| FFmpeg | Encodes video and audio | `brew install ffmpeg` | `apt-get install ffmpeg` |
| whisper.cpp | Transcription and captions | `brew install whisper-cpp` | built from source (cmake) |
| `hyperframes` CLI | init / preview / render | `npm i -g hyperframes` | same |
| Chrome Headless Shell | Renders frames | `hyperframes browser ensure` | same |

Run `hyperframes doctor` to check the result. Kokoro TTS, MusicGen and Docker are optional.

## Agent skills

The HyperFrames core skills live in `.claude/skills/`, so Claude Code loads them automatically in this repo.
Start with `/hyperframes`. To update them:

```bash
npx hyperframes skills update
```

Then copy the updated folders from `~/.claude/skills/` into `.claude/skills/`.

## Quick start

```bash
hyperframes init my-video
cd my-video
hyperframes preview     # live preview in the browser
hyperframes render      # writes an MP4
hyperframes transcribe path/to/audio.mp3   # whisper captions
```

Or ask Claude: *"Using /hyperframes, make a 10-second intro with a fade-in title."*
