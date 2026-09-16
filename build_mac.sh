#!/bin/bash
#
# build_mac.sh — Build CREATUBE STUDIO.app (macOS)
# ==================================================
# Cara pakai (di MacBook):
#   1. Install Python 3.10+  → https://www.python.org/downloads/mac-os/
#   2. Buka Terminal, masuk ke folder ini:
#        cd /path/to/creatube_mac
#   3. Install dependency:
#        python3 -m pip install pillow pyinstaller
#   4. Jalankan:
#        ./build_mac.sh
#
# Hasil: dist/CREATUBE STUDIO.app
#
# (Opsional) Bundle ffmpeg supaya user tidak perlu install brew:
#   1. Download ffmpeg untuk mac: https://evermeet.cx/ffmpeg/
#   2. Buat folder "ffmpeg/bin" di folder ini, lalu copy ffmpeg & ffprobe
#   3. Build ulang dengan script ini → otomatis terbundling
#
# ==================================================

set -e
cd "$(dirname "$0")"

echo "📦 CREATUBE STUDIO — macOS build"
echo "================================"
echo "Python: $(python3 --version 2>&1)"

# Cek dependency
if ! python3 -c "import PIL" 2>/dev/null; then
    echo "⚠️  Pillow belum terinstall. Install dengan:"
    echo "   python3 -m pip install pillow"
    exit 1
fi

if ! python3 -m PyInstaller --version >/dev/null 2>&1; then
    echo "⚠️  PyInstaller belum terinstall. Install dengan:"
    echo "   python3 -m pip install pyinstaller"
    exit 1
fi

echo "🧹 Membersihkan build lama..."
rm -rf build dist

# Bundling ffmpeg jika ada di folder lokal (opsional)
if [ -d "ffmpeg/bin" ] && [ -x "ffmpeg/bin/ffmpeg" ]; then
    echo "✅ ffmpeg lokal ditemukan → akan di-bundle"
else
    echo "ℹ️  ffmpeg lokal tidak ditemukan → app auto-detect brew/installasi sistem"
fi

echo "🚀 Building .app..."
python3 -m PyInstaller "CREATUBE_STUDIO.spec" --noconfirm --clean

# Copy ffmpeg lokal ke dalam bundle jika ada
if [ -d "ffmpeg/bin" ]; then
    APP="dist/CREATUBE STUDIO.app"
    if [ -d "$APP" ]; then
        echo "📦 Copy ffmpeg ke dalam bundle..."
        mkdir -p "$APP/Contents/Resources/ffmpeg/bin"
        cp -R ffmpeg/bin/* "$APP/Contents/Resources/ffmpeg/bin/" 2>/dev/null || true
    fi
fi

# Icon (opsional) — taruh icon.icns di folder ini
if [ -f "icon.icns" ]; then
    APP="dist/CREATUBE STUDIO.app"
    if [ -d "$APP" ]; then
        echo "🎨 Pasang icon..."
        cp icon.icns "$APP/Contents/Resources/icon.icns"
        /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string icon.icns" \
            "$APP/Contents/Info.plist" 2>/dev/null || true
    fi
fi

echo ""
echo "✅ BUILD SELESAI!"
echo "📁 Lokasi: dist/CREATUBE STUDIO.app"
echo ""
echo "Untuk test:"
echo "   open \"dist/CREATUBE STUDIO.app\""
echo ""
echo "Untuk distribusi (sign + notarize):"
echo "   codesign --deep --options runtime --sign 'Developer ID Application: NAMA' \"dist/CREATUBE STUDIO.app\""
echo "   xcrun notarytool submit \"dist/CREATUBE STUDIO.app.zip\" --keychain-profile 'profile' --wait"
echo ""
