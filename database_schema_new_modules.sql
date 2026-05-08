-- =====================================================
-- EmoVault New Modules Database Schema
-- =====================================================

-- 1. REGRET TABLE
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

-- 2. HABIT TABLE
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

-- 3. HABIT_LOG TABLE (Track daily completions)
CREATE TABLE IF NOT EXISTS habit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    habit_id INT NOT NULL,
    completed_date DATE NOT NULL,
    is_completed BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (habit_id) REFERENCES habits(habit_id) ON DELETE CASCADE,
    UNIQUE KEY unique_habit_date (habit_id, completed_date),
    INDEX (completed_date)
);

-- 4. ALERT TABLE
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

-- =====================================================
-- Sample Data (for testing)
-- =====================================================

-- Insert sample regrets (replace user_id 1 with actual user)
INSERT INTO regrets (user_id, description, lesson_learned, tag) VALUES
(1, 'Delayed the project start', 'Start tasks early', 'procrastination'),
(1, 'Did not communicate concerns', 'Speak up earlier', 'communication'),
(1, 'Stressed about deadline', 'Plan better', 'procrastination');

-- Insert sample habits
INSERT INTO habits (user_id, name, description, suggested_by_tag, is_active) VALUES
(1, 'Start tasks early', 'Begin work 30 minutes earlier', 'procrastination', TRUE),
(1, 'Daily breathing exercise', 'Practice 5-minute breathing', 'stress', TRUE),
(1, 'Speak up in meetings', 'Share one concern per meeting', 'communication', TRUE);

-- =====================================================
-- Queries to check data
-- =====================================================

-- View all regrets for user
-- SELECT * FROM regrets WHERE user_id = 1;

-- View all habits for user
-- SELECT * FROM habits WHERE user_id = 1;

-- View habit logs
-- SELECT hl.*, h.name FROM habit_logs hl JOIN habits h ON hl.habit_id = h.habit_id WHERE h.user_id = 1;

-- View alerts
-- SELECT * FROM alerts WHERE user_id = 1;
