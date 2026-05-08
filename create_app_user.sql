-- Create EmoVault database user with proper authentication
-- This script creates a dedicated user for the EmoVault application

-- Create the user 'emovault_user' with password 'emovault123'
-- Using mysql_native_password plugin for compatibility with MySQL 8.0 JDBC driver
CREATE USER IF NOT EXISTS 'emovault_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'emovault123';

-- Grant all privileges on emovault_db to this user
GRANT ALL PRIVILEGES ON emovault_db.* TO 'emovault_user'@'localhost';
GRANT ALL PRIVILEGES ON emovault.* TO 'emovault_user'@'localhost';

-- Also grant privileges for database creation (if needed)
GRANT CREATE ON *.* TO 'emovault_user'@'localhost';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- Verify the user was created
SELECT User, Host FROM mysql.user WHERE User = 'emovault_user';
