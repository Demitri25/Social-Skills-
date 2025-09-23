@echo off
title PEIS Installation - Pediatric Emotional Intelligence Scale
color 0A
echo.
echo ================================================================
echo  PEDIATRIC EMOTIONAL INTELLIGENCE SCALE (PEIS) INSTALLER
echo  Version 1.0 - Professional Assessment Tool
echo ================================================================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [INFO] Running with administrator privileges...
) else (
    echo [WARNING] Not running as administrator. Some features may be limited.
    echo           For full installation, right-click and "Run as administrator"
    echo.
)

REM Set installation directory
set INSTALL_DIR=%ProgramFiles%\PEIS
set USER_INSTALL_DIR=%USERPROFILE%\Documents\PEIS

echo [INFO] Checking installation files...

REM Check if required files exist
if not exist "emotional-intelligence-scale.html" (
    echo [ERROR] emotional-intelligence-scale.html not found!
    goto :error
)
if not exist "emotional-intelligence-scale.css" (
    echo [ERROR] emotional-intelligence-scale.css not found!
    goto :error
)
if not exist "emotional-intelligence-scale.js" (
    echo [ERROR] emotional-intelligence-scale.js not found!
    goto :error
)

echo [SUCCESS] All required files found.
echo.

REM Try to create program files directory first (requires admin)
echo [INFO] Attempting system-wide installation...
mkdir "%INSTALL_DIR%" 2>nul
if exist "%INSTALL_DIR%" (
    echo [SUCCESS] Created system directory: %INSTALL_DIR%
    set TARGET_DIR=%INSTALL_DIR%
    set INSTALL_TYPE=SYSTEM
) else (
    echo [INFO] System installation failed. Installing to user directory...
    mkdir "%USER_INSTALL_DIR%" 2>nul
    set TARGET_DIR=%USER_INSTALL_DIR%
    set INSTALL_TYPE=USER
)

echo [INFO] Installing to: %TARGET_DIR%
echo.

REM Copy files
echo [INFO] Copying assessment files...
copy "emotional-intelligence-scale.html" "%TARGET_DIR%\" >nul
copy "emotional-intelligence-scale.css" "%TARGET_DIR%\" >nul
copy "emotional-intelligence-scale.js" "%TARGET_DIR%\" >nul
copy "run-emotional-intelligence-evaluation.bat" "%TARGET_DIR%\" >nul

if %errorLevel% == 0 (
    echo [SUCCESS] Files copied successfully.
) else (
    echo [ERROR] Failed to copy files.
    goto :error
)

REM Create desktop shortcut
echo [INFO] Creating desktop shortcut...
set DESKTOP=%USERPROFILE%\Desktop
echo @echo off > "%DESKTOP%\PEIS Assessment.bat"
echo title Pediatric Emotional Intelligence Scale >> "%DESKTOP%\PEIS Assessment.bat"
echo cd /d "%TARGET_DIR%" >> "%DESKTOP%\PEIS Assessment.bat"
echo start "" "emotional-intelligence-scale.html" >> "%DESKTOP%\PEIS Assessment.bat"
echo echo PEIS Assessment opened in your browser. >> "%DESKTOP%\PEIS Assessment.bat"
echo pause >> "%DESKTOP%\PEIS Assessment.bat"

REM Create start menu shortcut (if system install)
if "%INSTALL_TYPE%"=="SYSTEM" (
    echo [INFO] Creating Start Menu shortcut...
    set STARTMENU=%ProgramData%\Microsoft\Windows\Start Menu\Programs
    mkdir "%STARTMENU%\PEIS" 2>nul
    echo @echo off > "%STARTMENU%\PEIS\PEIS Assessment.bat"
    echo title Pediatric Emotional Intelligence Scale >> "%STARTMENU%\PEIS\PEIS Assessment.bat"
    echo cd /d "%TARGET_DIR%" >> "%STARTMENU%\PEIS\PEIS Assessment.bat"
    echo start "" "emotional-intelligence-scale.html" >> "%STARTMENU%\PEIS\PEIS Assessment.bat"
    
    REM Create uninstaller
    echo [INFO] Creating uninstaller...
    echo @echo off > "%TARGET_DIR%\uninstall.bat"
    echo title PEIS Uninstaller >> "%TARGET_DIR%\uninstall.bat"
    echo echo Removing PEIS from your system... >> "%TARGET_DIR%\uninstall.bat"
    echo del "%DESKTOP%\PEIS Assessment.bat" 2^>nul >> "%TARGET_DIR%\uninstall.bat"
    echo rmdir /s /q "%STARTMENU%\PEIS" 2^>nul >> "%TARGET_DIR%\uninstall.bat"
    echo rmdir /s /q "%TARGET_DIR%" >> "%TARGET_DIR%\uninstall.bat"
    echo echo PEIS has been uninstalled. >> "%TARGET_DIR%\uninstall.bat"
    echo pause >> "%TARGET_DIR%\uninstall.bat"
) else (
    REM Create user start menu shortcut
    echo [INFO] Creating user Start Menu shortcut...
    set USER_STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs
    mkdir "%USER_STARTMENU%\PEIS" 2>nul
    echo @echo off > "%USER_STARTMENU%\PEIS\PEIS Assessment.bat"
    echo title Pediatric Emotional Intelligence Scale >> "%USER_STARTMENU%\PEIS\PEIS Assessment.bat"
    echo cd /d "%TARGET_DIR%" >> "%USER_STARTMENU%\PEIS\PEIS Assessment.bat"
    echo start "" "emotional-intelligence-scale.html" >> "%USER_STARTMENU%\PEIS\PEIS Assessment.bat"
    
    REM Create user uninstaller
    echo [INFO] Creating uninstaller...
    echo @echo off > "%TARGET_DIR%\uninstall.bat"
    echo title PEIS Uninstaller >> "%TARGET_DIR%\uninstall.bat"
    echo echo Removing PEIS from your system... >> "%TARGET_DIR%\uninstall.bat"
    echo del "%DESKTOP%\PEIS Assessment.bat" 2^>nul >> "%TARGET_DIR%\uninstall.bat"
    echo rmdir /s /q "%USER_STARTMENU%\PEIS" 2^>nul >> "%TARGET_DIR%\uninstall.bat"
    echo rmdir /s /q "%TARGET_DIR%" >> "%TARGET_DIR%\uninstall.bat"
    echo echo PEIS has been uninstalled. >> "%TARGET_DIR%\uninstall.bat"
    echo pause >> "%TARGET_DIR%\uninstall.bat"
)

REM Create documentation
echo [INFO] Creating documentation...
echo PEDIATRIC EMOTIONAL INTELLIGENCE SCALE (PEIS) > "%TARGET_DIR%\README.txt"
echo ============================================== >> "%TARGET_DIR%\README.txt"
echo. >> "%TARGET_DIR%\README.txt"
echo Version: 1.0 >> "%TARGET_DIR%\README.txt"
echo Age Range: 2.5 - 18 years >> "%TARGET_DIR%\README.txt"
echo Questions: 30 items across 5 domains >> "%TARGET_DIR%\README.txt"
echo. >> "%TARGET_DIR%\README.txt"
echo DOMAINS: >> "%TARGET_DIR%\README.txt"
echo 1. Self-Awareness (Questions 1-6) >> "%TARGET_DIR%\README.txt"
echo 2. Self-Regulation (Questions 7-12) >> "%TARGET_DIR%\README.txt"
echo 3. Motivation (Questions 13-18) >> "%TARGET_DIR%\README.txt"
echo 4. Empathy (Questions 19-24) >> "%TARGET_DIR%\README.txt"
echo 5. Social Skills (Questions 25-30) >> "%TARGET_DIR%\README.txt"
echo. >> "%TARGET_DIR%\README.txt"
echo SCORING: >> "%TARGET_DIR%\README.txt"
echo - Standard Score of 100 = Age-appropriate EI >> "%TARGET_DIR%\README.txt"
echo - Scores range from 40-160 >> "%TARGET_DIR%\README.txt"
echo - Includes emotional age equivalents >> "%TARGET_DIR%\README.txt"
echo. >> "%TARGET_DIR%\README.txt"
echo HOW TO USE: >> "%TARGET_DIR%\README.txt"
echo 1. Double-click desktop shortcut "PEIS Assessment" >> "%TARGET_DIR%\README.txt"
echo 2. Complete child information form >> "%TARGET_DIR%\README.txt"
echo 3. Answer all 30 assessment questions >> "%TARGET_DIR%\README.txt"
echo 4. Click "Calculate EI Score" for results >> "%TARGET_DIR%\README.txt"
echo. >> "%TARGET_DIR%\README.txt"
echo INSTALLATION DETAILS: >> "%TARGET_DIR%\README.txt"
echo Installation Type: %INSTALL_TYPE% >> "%TARGET_DIR%\README.txt"
echo Installation Path: %TARGET_DIR% >> "%TARGET_DIR%\README.txt"
echo Installation Date: %DATE% %TIME% >> "%TARGET_DIR%\README.txt"

echo.
echo ================================================================
echo  INSTALLATION COMPLETE!
echo ================================================================
echo.
echo Installation Type: %INSTALL_TYPE%
echo Installation Path: %TARGET_DIR%
echo.
echo SHORTCUTS CREATED:
echo - Desktop: "PEIS Assessment.bat"
if "%INSTALL_TYPE%"=="SYSTEM" (
    echo - Start Menu: Programs ^> PEIS ^> PEIS Assessment
) else (
    echo - Start Menu: %USER_STARTMENU%\PEIS
)
echo.
echo HOW TO USE:
echo 1. Double-click the desktop shortcut "PEIS Assessment"
echo 2. The assessment will open in your web browser
echo 3. Complete the evaluation and get instant results
echo.
echo TO UNINSTALL:
echo - Run: %TARGET_DIR%\uninstall.bat
echo.
echo The PEIS assessment is now ready to use!
echo.
goto :end

:error
echo.
echo [ERROR] Installation failed!
echo Please ensure all required files are present:
echo - emotional-intelligence-scale.html
echo - emotional-intelligence-scale.css
echo - emotional-intelligence-scale.js
echo - run-emotional-intelligence-evaluation.bat
echo.

:end
echo Press any key to exit...
pause >nul