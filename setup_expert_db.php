<?php
// Expert System Database Setup Script
// This script creates the necessary tables for the Expert authentication system

try {
    // MySQL connection - try with no password first, then with different hosts
    @$conn = new mysqli("127.0.0.1", "root", "", "emovault", 3306);
    
    if (!$conn || $conn->connect_error) {
        @$conn = new mysqli("localhost", "root", null, "emovault", 3306);
    }
    
    if (!$conn || $conn->connect_error) {
        die("Connection failed. Please ensure MySQL is running and accessible.\n");
    }
    
    echo "Connected to database successfully\n";
    
    // Create expert_accounts table
    $sql1 = "CREATE TABLE IF NOT EXISTS expert_accounts (
        expert_id INT PRIMARY KEY AUTO_INCREMENT,
        expert_uid VARCHAR(50) UNIQUE NOT NULL,
        expert_name VARCHAR(100) NOT NULL,
        role VARCHAR(50) DEFAULT 'EXPERT',
        password_hash VARCHAR(255) NOT NULL,
        email VARCHAR(100),
        is_active TINYINT DEFAULT 1,
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_login TIMESTAMP NULL,
        INDEX idx_uid (expert_uid),
        INDEX idx_active (is_active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
    
    if ($conn->query($sql1) === TRUE) {
        echo "✓ expert_accounts table created/verified\n";
    } else {
        echo "✗ Error creating expert_accounts table: " . $conn->error . "\n";
    }
    
    // Create expert_activity_log table
    $sql2 = "CREATE TABLE IF NOT EXISTS expert_activity_log (
        log_id INT PRIMARY KEY AUTO_INCREMENT,
        expert_id INT NOT NULL,
        action VARCHAR(100) NOT NULL,
        details TEXT,
        ip_address VARCHAR(45),
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (expert_id) REFERENCES expert_accounts(expert_id) ON DELETE CASCADE,
        INDEX idx_expert (expert_id),
        INDEX idx_action (action),
        INDEX idx_date (created_date)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
    
    if ($conn->query($sql2) === TRUE) {
        echo "✓ expert_activity_log table created/verified\n";
    } else {
        echo "✗ Error creating expert_activity_log table: " . $conn->error . "\n";
    }
    
    // Insert default Expert account if not exists
    $checkSQL = "SELECT expert_id FROM expert_accounts WHERE expert_uid = 'expert_main' LIMIT 1";
    $result = $conn->query($checkSQL);
    
    if ($result->num_rows == 0) {
        // Password hash for 'expert123' using bcrypt
        $phash = "$2a$10$t.b5RLmTCcREE.bCdQQK.eVbGjKhC27p1CwPvEEzOgNeqCB.bLJ7m";
        $insertSQL = "INSERT INTO expert_accounts (expert_uid, expert_name, role, password_hash, email)
                      VALUES ('expert_main', 'Expert System Admin', 'ADMIN', '$phash', 'expert@emovault.local')";
        
        if ($conn->query($insertSQL) === TRUE) {
            echo "✓ Default Expert account created\n";
            echo "  ID: expert_main\n";
            echo "  Password: expert123 (CHANGE THIS AFTER LOGIN!)\n";
        } else {
            echo "✗ Error inserting default Expert: " . $conn->error . "\n";
        }
    } else {
        echo "ℹ️  Default Expert account already exists\n";
    }
    
    // Log system initialization
    $logSQL = "INSERT INTO expert_activity_log (expert_id, action, details, ip_address)
               SELECT expert_id, 'SYSTEM_INIT', 'Expert system database initialized', '127.0.0.1'
               FROM expert_accounts WHERE expert_uid = 'expert_main' LIMIT 1";
    $conn->query($logSQL);
    
    echo "\n✓ Expert System database setup complete!\n";
    echo "\nNEXT STEPS:\n";
    echo "1. Access http://localhost:8080/EmoVault/expert_login.jsp\n";
    echo "2. Login with:\n";
    echo "   Expert ID: expert_main\n";
    echo "   Password: expert123\n";
    echo "3. Change the default password immediately\n";
    
    $conn->close();
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>
