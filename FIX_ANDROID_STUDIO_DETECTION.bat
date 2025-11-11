@echo off
echo ========================================
echo Fix Android Studio APK Detection Issue
echo ========================================
echo.
echo Problem: "List of apks: [0]" means Android Studio
echo can't find the APK even though it exists.
echo.
echo.

echo Step 1: Copying APK to correct location...
if exist "app\build\intermediates\apk\debug\app-debug.apk" (
    echo Found APK at: app\build\intermediates\apk\debug\app-debug.apk
    echo.
    echo Creating outputs directory...
    if not exist "app\build\outputs\apk\debug" mkdir "app\build\outputs\apk\debug"
    echo.
    echo Copying APK to outputs folder...
    copy /Y "app\build\intermediates\apk\debug\app-debug.apk" "app\build\outputs\apk\debug\app-debug.apk"
    if %ERRORLEVEL% EQU 0 (
        echo SUCCESS: APK copied to outputs folder!
    ) else (
        echo ERROR: Failed to copy APK
        pause
        exit /b 1
    )
) else (
    echo ERROR: APK not found at intermediates location!
    echo Please build the project first.
    pause
    exit /b 1
)

echo.
echo Step 2: Verifying APK exists in outputs...
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo SUCCESS: APK now exists in outputs folder!
    for %%F in ("app\build\outputs\apk\debug\app-debug.apk") do (
        echo APK Size: %%~zF bytes
        echo APK Date: %%~tF
    )
) else (
    echo ERROR: APK still not in outputs folder!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Fix Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Go back to Android Studio
echo 2. Try Run -^> Run 'app' again
echo 3. If still fails, use install_apk_manually.bat instead
echo.
pause

