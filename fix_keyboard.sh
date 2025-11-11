#!/bin/bash

# ========================================
# FIX EMULATOR KEYBOARD INPUT ISSUE
# ========================================
# Run this script anytime you can't type in the emulator
# Usage: ./fix_keyboard.sh

echo "🔧 Fixing emulator keyboard input issue..."
echo ""

# Step 1: Enable soft keyboard to show with hardware keyboard
echo "✓ Enabling soft keyboard..."
adb shell settings put secure show_ime_with_hard_keyboard 1

# Step 2: Restart ADB server
echo "✓ Restarting ADB server..."
adb kill-server
adb start-server

# Wait for device
sleep 2

# Step 3: Set Google Keyboard as default
echo "✓ Setting Google Keyboard as default input method..."
adb shell ime enable com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME
adb shell ime set com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME

echo ""
echo "✅ Keyboard fix applied!"
echo ""
echo "📱 Now try typing in your app. If still not working:"
echo "   1. Close and reopen the app"
echo "   2. Or restart the emulator"
echo "   3. In emulator, go to Settings > System > Languages & input > On-screen keyboard"
echo ""

