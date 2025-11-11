@echo off
echo ========================================
echo Fix Package Manager Service Error
echo ========================================
echo.
echo Error: "cmd: Can't find service: package"
echo This means the emulator's package manager isn't ready.
echo.
echo.

echo Step 1: Stopping emulator...
adb emu kill
timeout /t 3 /nobreak >nul

echo Step 2: Restarting ADB...
adb kill-server
timeout /t 2 /nobreak >nul
adb start-server
timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo IMPORTANT: Manual Steps Required!
echo ========================================
echo.
echo Please do the following in Android Studio:
echo.
echo 1. Open Device Manager (Tools -^> Device Manager)
echo.
echo 2. Stop the current emulator if it's running
echo.
echo 3. Start emulator with COLD BOOT:
echo    - Click the DROPDOWN (▼) next to emulator name
echo    - Select "Cold Boot Now" (NOT regular Start!)
echo.
echo 4. WAIT for emulator to fully boot:
echo    - Wait until you see Android HOME SCREEN
echo    - Do NOT try to install while emulator is still booting
echo    - This can take 30-60 seconds
echo.
echo 5. Once emulator is fully booted (home screen visible):
echo    - Come back here and press any key
echo    - I will verify package manager is ready
echo    - Then install the app
echo.
pause

echo.
echo Step 3: Checking if emulator is running...
adb devices
echo.

echo Step 4: Waiting for package manager service...
echo (This may take up to 30 seconds...)
:wait_loop
adb shell "pm list packages" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Waiting for package manager...
    timeout /t 2 /nobreak >nul
    goto wait_loop
)
echo Package manager is ready!
echo.

echo Step 5: Uninstalling existing app (if any)...
adb uninstall com.kelasandroidappsirhafizee.tempahanphotostudio 2>nul
echo.

echo Step 6: Installing APK...
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo Installing from outputs folder...
    adb install -r "app\build\outputs\apk\debug\app-debug.apk"
) else if exist "app\build\intermediates\apk\debug\app-debug.apk" (
    echo Installing from intermediates folder...
    adb install -r "app\build\intermediates\apk\debug\app-debug.apk"
) else (
    echo ERROR: APK not found!
    echo Please build the project first.
    pause
    exit /b 1
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! App installed successfully!
    echo ========================================
    echo.
    echo The app should now be installed on your emulator.
) else (
    echo.
    echo ========================================
    echo INSTALLATION FAILED!
    echo ========================================
    echo.
    echo The package manager service is still not ready.
    echo.
    echo Try this:
    echo 1. Make sure emulator is FULLY booted (home screen visible)
    echo 2. Wait 10 more seconds after home screen appears
    echo 3. Run this script again
    echo.
    echo OR:
    echo - Close emulator completely
    echo - Cold Boot emulator again
    echo - Wait for full boot
    echo - Run this script again
    echo.
)

echo.
pause

