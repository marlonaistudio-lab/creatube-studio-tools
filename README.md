# CREATUBE STUDIO Tools

Advanced Audio/Video Mixer — loop video, merge video + audio + FX, inspect metadata.

**Binary build otomatis via GitHub Actions.** Setiap push ke `main` menghasilkan:
- 🍎 `CREATUBE-STUDIO-macOS-macos-13.zip` (Intel x86_64)
- 🍎 `CREATUBE-STUDIO-macOS-macos-14.zip` (Apple Silicon arm64)
- 🪟 `CREATUBE-STUDIO-Windows.zip`

Download dari **Actions → pilih run → scroll ke Artifacts**.

## Build manual

```bash
python3 -m pip install pillow pyinstaller
./build_mac.sh          # macOS
build_windows.bat       # Windows
```

## FFmpeg

App auto-detect FFmpeg dari Homebrew (`/opt/homebrew/bin`, `/usr/local/bin`),
MacPorts, PATH, atau folder bundle. Jika tidak ada, pesan error akan muncul
beserta instruksi install (`brew install ffmpeg`).

Untuk bundle FFmpeg ke dalam app: taruh binary `ffmpeg` + `ffprobe` di
subfolder `ffmpeg/bin/` sebelum build — otomatis terbaca.
