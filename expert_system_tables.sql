-- Expert System Database Tables

-- Create expert_accounts table for Expert authentication
CREATE TABLE IF NOT EXISTS expert_accounts (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create expert_activity_log table for tracking Expert actions
CREATE TABLE IF NOT EXISTS expert_activity_log (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Default Expert account
-- Expert ID: expert_main
-- Password: expert123 (change this after setup!)
INSERT IGNORE INTO expert_accounts (expert_uid, expert_name, role, password_hash, email)
VALUES (
    'expert_main',
    'Expert System Admin',
    'ADMIN',
    '$2a$10$t.b5RLmTCcREE.bCdQQK.eVbGjKhC27p1CwPvEEzOgNeqCB.bLJ7m', -- hashed 'expert123'
    'expert@emovault.local'
);

-- Insert sample activity log entry
INSERT IGNORE INTO expert_activity_log (expert_id, action, details, ip_address)
VALUES (
    1,
    'SYSTEM_INIT',
    'Expert system initialized',
    '127.0.0.1'
);

-- Grant appropriate permissions
-- Note: Execute as database administrator
-- e.g., GRANT SELECT, INSERT, UPDATE, DELETE ON emovault.expert_* TO 'emovault'@'localhost';
