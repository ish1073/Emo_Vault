@echo off
echo Running EmoVault Database Setup...
cd C:\xampp\mysql\bin
mysql.exe -u root < D:\itsme\Workk\EmoVault\database\emovault_schema.sql
echo Database setup complete!
pause
