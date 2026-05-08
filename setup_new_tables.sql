USE emovault;

CREATE TABLE IF NOT EXISTS regrets (
    regret_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    description VARCHAR(500) NOT NULL,
    lesson_learned VARCHAR(500),
    tag VARCHAR(50) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX (user_id),
    INDEX (tag)
);

CREATE TABLE IF NOT EXISTS habits (
    habit_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(500),
    suggested_by_tag VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX (user_id)
);

CREATE TABLE IF NOT EXISTS habit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    habit_id INT NOT NULL,
    completed_date DATE NOT NULL,
    is_completed BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (habit_id) REFERENCES habits(habit_id) ON DELETE CASCADE,
    UNIQUE KEY unique_habit_date (habit_id, completed_date),
    INDEX (completed_date)
);

CREATE TABLE IF NOT EXISTS alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    message VARCHAR(500) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX (user_id),
    INDEX (is_read)
);

-- Verify tables
SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'emovault' AND TABLE_NAME IN ('regrets', 'habits', 'habit_logs', 'alerts');
