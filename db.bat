@echo off
setlocal enabledelayedexpansion
title Rivals DB

:start
cls
echo ========================================
echo       RIVALS SKIN DATABASE
echo ========================================
echo Categories: p/ (Primary), s/ (Secondary)
set /p "cat_input=> "

if /i "%cat_input%"=="p/" (
    set "category=Primary"
) else if /i "%cat_input%"=="s/" (
    set "category=Secondary"
) else (
    echo Unknown category.
    pause
    goto start
)

echo.
echo Searching %category%...
echo Enter Weapon Tag (e.g., ar, akey, aug):
set /p "tag_input=> "

:: This PowerShell script now loops through ALL weapon types (AR, SMG, etc.)
powershell -Command ^
    "$data = Get-Content 'skins.json' | ConvertFrom-Json;" ^
    "$found = $false;" ^
    "$catData = $data.Weapons.%category%;" ^
    "foreach ($weaponType in $catData.psobject.Properties.Name) {" ^
    "    $skins = $catData.$weaponType.skins;" ^
    "    foreach ($skinKey in $skins.psobject.Properties.Name) {" ^
    "        if ($skins.$skinKey.tag -eq '%cat_input%%tag_input%') {" ^
    "            Write-Host '----------------------------------------' -ForegroundColor Cyan;" ^
    "            Write-Host 'WEAPON: ' $catData.$weaponType.name;" ^
    "            Write-Host 'SKIN:   ' $skins.$skinKey.name;" ^
    "            Write-Host 'RARITY: ' $skins.$skinKey.rarity;" ^
    "            Write-Host 'STATUS: ' $skins.$skinKey.status;" ^
    "            Write-Host 'FROM:   ' $skins.$skinKey.from;" ^
    "            Write-Host '----------------------------------------' -ForegroundColor Cyan;" ^
    "            $found = $true;" ^
    "        }" ^
    "    }" ^
    "};" ^
    "if (-not $found) { Write-Host 'No skin found with tag %cat_input%%tag_input%' -ForegroundColor Red }"

echo.
echo Press any key to search again...
pause > nul