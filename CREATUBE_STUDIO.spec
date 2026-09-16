# -*- mode: python ; coding: utf-8 -*-
#
# CREATUBE STUDIO — PyInstaller spec (macOS .app + Windows .exe)
# =============================================================
# Build commands:
#
#   macOS  (hasil: dist/CREATUBE STUDIO.app):
#     python3 -m PyInstaller "CREATUBE_STUDIO.spec"      # atau: ./build_mac.sh
#
#   Windows (hasil: dist/CREATUBE STUDIO.exe):
#     pyinstaller "CREATUBE_STUDIO.spec"                 # atau: build_windows.bat
#
# Catatan Penting Mac:
#   - Pakai windowed=True (tidak ada jendela Terminal di belakang app)
#   - settings.json disimpan di ~/Library/Application Support/CREATUBE STUDIO
#     (BUKAN di dalam .app) → aman saat app di-update/ditimpa
#   - ffmpeg/ffprobe/ffprobe TIDAK dibundle. Aplikasi auto-detect brew.
#     Kalau mau bundle ffmpeg, taruh binary di subfolder "ffmpeg/bin" sebelum
#     build, atau copy manual ke dalam .app setelahnya.

import sys

block_cipher = None

a = Analysis(
    ['CREATUBE_STUDIO.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[
        # PIL dipakai untuk logo base64 & icon; pastikan terbundling
        'PIL',
        'PIL.Image',
        'PIL.ImageTk',
        # Tkinter & modul yang dipakai tkinter secara dinamis
        'tkinter',
        'tkinter.filedialog',
        'tkinter.messagebox',
        'tkinter.font',
        'tkinter.ttk',
        '_tkinter',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        # Hanya exclude yang benar-benar tidak dipakai. Jangan exclude
        # urllib/http/xml/email — dibutuhkan stdlib internal (zipfile,
        # inspect, pkgutil) dan akan crash saat startup.
        'tkinter.test',
        'unittest',
        'pydoc_data',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

# --- macOS: bangun .app bundle -------------------------------------------
# onefile=False (onedir) dipilih karena:
#   1. Startup lebih cepat (tidak perlu extract ke temp dulu)
#   2. settings.json bisa disimpan permanen di Application Support
#      meski begitu, APP_DIR sudah mengarah ke Application Support saat frozen
exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='CREATUBE STUDIO',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,                 # windowed: tanpa jendela Terminal
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,              # None = arsitektur mesin build (arm64/x86_64)
    codesign_identity=None,        # isi nama identity kalau mau di-sign
    entitlements_file=None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=False,
    name='CREATUBE STUDIO',
)
