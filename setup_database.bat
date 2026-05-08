@echo off
REM Database Setup Script for EmoVault New Modules

echo Setting up EmoVault database tables...
echo.

cd /d "C:\xampp\mysql\bin"

REM Execute SQL setup
mysql.exe -h localhost -u root emovault < "d:\itsme\Workk\EmoVault\setup_new_tables.sql"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ Database setup completed successfully!
    echo.
    echo Tables created:
    echo - regrets
    echo - habits
    echo - habit_logs
    echo - alerts
    echo.
    echo You can now access the new features:
    echo - http://localhost:8080/EmoVault/regret
    echo - http://localhost:8080/EmoVault/habit
    echo - http://localhost:8080/EmoVault/alert
) else (
    echo.
    echo ✗ Error during database setup
    echo Check MySQL is running and try again
)

pause
