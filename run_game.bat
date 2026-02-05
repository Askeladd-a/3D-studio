@echo off
REM Launcher per Scriptorium Alchimico
REM Usa: run_game.bat [mode]
REM Modes: dice (solo dadi 3D), game (gioco completo)

set LOVE="C:\Program Files\LOVE\love.exe"
set GAME_DIR=%~dp0

if "%1"=="game" goto game
if "%1"=="dice" goto dice
goto menu

:menu
echo.
echo ====================================
echo   SCRIPTORIUM ALCHIMICO LAUNCHER
echo ====================================
echo.
echo   1. Gioco completo (main_game.lua)
echo   2. Solo dadi 3D (main.lua)
echo   3. Esci
echo.
set /p choice="Scegli [1-3]: "
if "%choice%"=="1" goto game
if "%choice%"=="2" goto dice
if "%choice%"=="3" exit
goto menu

:game
echo Avvio gioco completo...
copy /Y "%GAME_DIR%main_game.lua" "%GAME_DIR%main_temp.lua" >nul
copy /Y "%GAME_DIR%main.lua" "%GAME_DIR%main_backup_temp.lua" >nul
copy /Y "%GAME_DIR%main_game.lua" "%GAME_DIR%main.lua" >nul
%LOVE% "%GAME_DIR%"
copy /Y "%GAME_DIR%main_backup_temp.lua" "%GAME_DIR%main.lua" >nul
del "%GAME_DIR%main_temp.lua" 2>nul
del "%GAME_DIR%main_backup_temp.lua" 2>nul
goto end

:dice
echo Avvio modalità dadi 3D...
%LOVE% "%GAME_DIR%"
goto end

:end
echo.
