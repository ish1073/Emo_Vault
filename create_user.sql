CREATE USER IF NOT EXISTS 'emovault_user'@'localhost' IDENTIFIED BY 'emovault123';
GRANT ALL PRIVILEGES ON emovault_db.* TO 'emovault_user'@'localhost';
GRANT ALL PRIVILEGES ON emovault.* TO 'emovault_user'@'localhost';
FLUSH PRIVILEGES;
