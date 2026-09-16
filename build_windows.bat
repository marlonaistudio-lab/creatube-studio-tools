@echo off
REM ==================================================
REM build_windows.bat - Build CREATUBE STUDIO.exe (Windows)
REM ==================================================
REM Cara pakai (di Windows):
REM   1. Install Python 3.10+ (centang "Add Python to PATH")
REM   2. Buka Command Prompt, masuk ke folder ini:
REM        cd /d C:\path\to\creatube_mac
REM   3. Install dependency:
REM        python -m pip install pillow pyinstaller
REM   4. Jalankan:
REM        build_windows.bat
REM
REM Hasil: dist\CREATUBE STUDIO.exe
REM ==================================================

cd /d "%~dp0"

echo ==================================================
echo  CREATUBE STUDIO - Windows build
echo ==================================================
python --version

REM Cek dependency
python -c "import PIL" 2>nul
if errorlevel 1 (
    echo [!] Pillow belum terinstall. Install dengan:
    echo     python -m pip install pillow
    pause
    exit /b 1
)

python -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
    echo [!] PyInstaller belum terinstall. Install dengan:
    echo     python -m pip install pyinstaller
    pause
    exit /b 1
)

echo [..] Membersihkan build lama...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist

REM Bundle ffmpeg lokal kalau ada
if exist "ffmpeg\bin\ffmpeg.exe" (
    echo [OK] ffmpeg lokal ditemukan - akan di-bundle
) else (
    echo [i] ffmpeg lokal tidak ditemukan - app auto-detect dari PATH/winget
)

echo [..] Building .exe...
python -m PyInstaller "CREATUBE_STUDIO.spec" --noconfirm --clean
if errorlevel 1 (
    echo [X] BUILD GAGAL!
    pause
    exit /b 1
)

REM Copy ffmpeg lokal ke dalam folder hasil (sebelahan exe, bukan di dalam)
if exist "ffmpeg\bin" (
    echo [..] Copy ffmpeg ke folder hasil...
    xcopy /e /i /y "ffmpeg\bin\*" "dist\CREATUBE STUDIO\ffmpeg\bin\" >nul 2>&1
)

REM Icon (opsional)
if exist "icon.ico" (
    echo [..] icon.ico terdeteksi - dipakai oleh spec
)

echo.
echo [OK] BUILD SELESAI!
echo [..] Lokasi: dist\CREATUBE STUDIO.exe
echo.
pause
