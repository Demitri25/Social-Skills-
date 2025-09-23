@echo off
title Pediatric Emotional Intelligence Scale (PEIS)
echo.
echo ========================================
echo  Pediatric Emotional Intelligence Scale
echo  Ages 2.5 - 18 Years Assessment Tool
echo ========================================
echo.
echo Starting the emotional intelligence evaluation...
echo.

REM Check if the HTML file exists
if not exist "emotional-intelligence-scale.html" (
    echo ERROR: emotional-intelligence-scale.html not found!
    echo Please ensure the assessment files are in the same directory.
    pause
    exit /b 1
)

REM Open the assessment in the default browser
start "" "emotional-intelligence-scale.html"

echo Assessment opened in your default web browser.
echo.
echo Instructions:
echo 1. Complete the child information form
echo 2. Answer all 30 assessment questions
echo 3. Click "Calculate EI Score" to get results
echo.
echo The assessment includes:
echo - Self-Awareness (Questions 1-6)
echo - Self-Regulation (Questions 7-12)
echo - Motivation (Questions 13-18)
echo - Empathy (Questions 19-24)
echo - Social Skills (Questions 25-30)
echo.
echo Standard Score of 100 = Age-appropriate emotional intelligence
echo.
echo Press any key to close this window...
pause >nul