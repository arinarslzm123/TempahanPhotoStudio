@echo off
echo ========================================
echo Manual APK Installation
echo ========================================
echo.

echo Step 1: Checking ADB connection...
adb devices
echo.

echo Step 2: Uninstalling existing app (if any)...
adb uninstall com.kelasandroidappsirhafizee.tempahanphotostudio
echo.

echo Step 3: Looking for APK file...
if exist "app\build\intermediates\apk\debug\app-debug.apk" (
    echo APK found at: app\build\intermediates\apk\debug\app-debug.apk
    set APK_PATH=app\build\intermediates\apk\debug\app-debug.apk
    goto :found_apk
)
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo APK found at: app\build\outputs\apk\debug\app-debug.apk
    set APK_PATH=app\build\outputs\apk\debug\app-debug.apk
    goto :found_apk
)

echo ERROR: APK not found!
echo.
echo Please build the APK first:
echo 1. Open Android Studio
echo 2. Build -^> Build Bundle(s) / APK(s) -^> Build APK(s)
echo 3. Wait for build to complete
echo 4. Run this script again
echo.
pause
exit /b 1

:found_apk
for %%F in ("%APK_PATH%") do (
    echo APK Size: %%~zF bytes
    echo APK Date: %%~tF
)
echo.

echo.
echo Step 4: Installing APK...
adb install -r "%APK_PATH%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! App installed successfully!
    echo ========================================
    echo.
    echo The app should now appear on your emulator.
    echo If it doesn't launch automatically, find it in the app drawer.
) else (
    echo.
    echo ========================================
    echo INSTALLATION FAILED!
    echo ========================================
    echo.
    echo Error code: %ERRORLEVEL%
    echo.
    echo Try these solutions:
    echo 1. Make sure emulator is fully booted
    echo 2. Run fix_adb_installation.bat first
    echo 3. Cold Boot emulator (Device Manager -^> dropdown -^> Cold Boot Now)
    echo 4. Check if device is online: adb devices
    echo.
)

echo.
pause

