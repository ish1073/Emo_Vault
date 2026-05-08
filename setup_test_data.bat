@echo off
REM EmoVault Test Data Setup Script
REM This script adds test data to the database to demonstrate features

echo.
echo ============================================
echo EmoVault Test Data Setup
echo ============================================
echo.

REM Run the SQL script
"C:\xampp\mysql\bin\mysql.exe" -h localhost -u root -pPassword123 emovault_db < create_test_data.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo ✓ Test data created successfully!
    echo ============================================
    echo.
    echo LOGIN CREDENTIALS:
    echo   Email: testuser@example.com
    echo   Password: test123
    echo.
    echo You can now:
    echo   1. Log in with the credentials above
    echo   2. Go to Behavior Analyzer to see emotional insights
    echo   3. Go to Time Capsule to see reflections
    echo   4. Go to Analytics & Reports for charts
    echo.
    pause
) else (
    echo.
    echo ============================================
    echo X Error creating test data
    echo ============================================
    echo.
    echo Please ensure:
    echo   1. MySQL is running (check XAMPP Control Panel)
    echo   2. Database "emovault_db" exists
    echo   3. MySQL credentials are correct
    echo.
    pause
)
