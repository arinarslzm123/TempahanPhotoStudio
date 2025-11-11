@echo off
echo ========================================
echo Fixing ADB Installation Issue
echo ========================================
echo.

echo Step 1: Killing ADB server and all ADB processes...
adb kill-server
timeout /t 2 /nobreak >nul
taskkill /F /IM adb.exe 2>nul
timeout /t 2 /nobreak >nul

echo Step 2: Starting ADB server...
adb start-server
timeout /t 3 /nobreak >nul

echo Step 3: Waiting for emulator to be ready...
timeout /t 5 /nobreak >nul

echo Step 4: Checking connected devices...
echo.
adb devices -l
echo.

echo Step 5: Verifying device is online...
for /f "tokens=2" %%a in ('adb devices ^| findstr "device$"') do (
    echo Device found: %%a
    set DEVICE_FOUND=1
)

if not defined DEVICE_FOUND (
    echo WARNING: No device found! Make sure emulator is running.
    echo.
    echo Please:
    echo 1. Open Android Studio
    echo 2. Tools -^> Device Manager
    echo 3. Start/Cold Boot emulator
    echo 4. Run this script again
    echo.
    pause
    exit /b 1
)

echo Step 6: Waiting for package manager service...
adb wait-for-device shell 'while ! getprop sys.boot_completed 2^>^&1; do sleep 1; done'
timeout /t 3 /nobreak >nul

echo Step 7: Checking if app is already installed...
adb shell pm list packages | findstr tempahanphotostudio
echo.

echo Step 8: Uninstalling existing app (if any)...
adb uninstall com.kelasandroidappsirhafizee.tempahanphotostudio
echo Uninstall complete (may show error if app not installed - that's OK)
echo.

echo Step 9: Verifying APK exists...
if exist "app\build\intermediates\apk\debug\app-debug.apk" (
    echo APK found at: app\build\intermediates\apk\debug\app-debug.apk
) else if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo APK found at: app\build\outputs\apk\debug\app-debug.apk
) else (
    echo WARNING: APK not found! You need to build the project first.
)

echo.
echo ========================================
echo Fix Complete!
echo ========================================
echo.
echo Next steps in Android Studio:
echo 1. File -^> Invalidate Caches -^> Invalidate and Restart
echo 2. Wait for Android Studio to restart
echo 3. Build -^> Clean Project
echo 4. Build -^> Rebuild Project
echo 5. Make sure emulator is FULLY booted (home screen visible)
echo 6. Run -^> Run 'app'
echo.
echo If still fails, try:
echo - Cold Boot emulator (Device Manager -^> dropdown -^> Cold Boot Now)
echo - Use physical device instead
echo.
pause

