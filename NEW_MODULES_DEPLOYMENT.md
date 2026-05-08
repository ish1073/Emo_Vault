-- =====================================================
-- EmoVault New Modules - Implementation Summary
-- =====================================================

-- Database Setup Instructions:
-- 1. Open MySQL Command Line or MySQL Workbench
-- 2. Connect to your EmoVault database
-- 3. Copy and paste the following SQL statements
-- 4. Execute each CREATE TABLE statement

-- =====================================================
-- CREATE TABLES (Run these in MySQL)
-- =====================================================

USE emovault;

-- Table 1: REGRETS
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

-- Table 2: HABITS
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

-- Table 3: HABIT_LOGS (Tracks daily completions)
CREATE TABLE IF NOT EXISTS habit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    habit_id INT NOT NULL,
    completed_date DATE NOT NULL,
    is_completed BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (habit_id) REFERENCES habits(habit_id) ON DELETE CASCADE,
    UNIQUE KEY unique_habit_date (habit_id, completed_date),
    INDEX (completed_date)
);

-- Table 4: ALERTS
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
-- DEPLOYMENT VERIFICATION QUERIES
-- =====================================================

-- Check if tables exist:
-- SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'emovault';

-- View your regrets (for user_id 1):
-- SELECT * FROM regrets WHERE user_id = 1;

-- View your habits:
-- SELECT * FROM habits WHERE user_id = 1;

-- View habit completion logs:
-- SELECT hl.*, h.name FROM habit_logs hl JOIN habits h ON hl.habit_id = h.habit_id WHERE h.user_id = 1;

-- View alerts:
-- SELECT * FROM alerts WHERE user_id = 1;

-- =====================================================
-- WEB.XML SERVLET MAPPINGS (Already Added)
-- =====================================================

-- The following servlet mappings have been added to web.xml:
-- 
-- RegretServlet  -> /regret  (GET/POST)
-- HabitServlet   -> /habit   (GET/POST) 
-- AlertServlet   -> /alert   (GET/POST)
--
-- All URLs are accessible as:
-- - http://localhost:8080/EmoVault/regret
-- - http://localhost:8080/EmoVault/habit  
-- - http://localhost:8080/EmoVault/alert

-- =====================================================
-- FILES DEPLOYMENT CHECKLIST
-- =====================================================

-- ✓ Model Classes (in WEB-INF/classes):
--   - Regret.class
--   - Habit.class
--   - Alert.class

-- ✓ DAO Classes (in WEB-INF/classes):
--   - RegretDAO.class
--   - HabitDAO.class
--   - AlertDAO.class

-- ✓ Servlet Classes (in WEB-INF/classes):
--   - RegretServlet.class
--   - HabitServlet.class
--   - AlertServlet.class

-- ✓ Utility Classes (in WEB-INF/classes):
--   - RiskAnalyzer.class

-- ✓ JSP Pages (in webapps/EmoVault):
--   - regret.jsp
--   - habit.jsp
--   - alert.jsp

-- ✓ Configuration (web.xml):
--   - 3 new servlet mappings added
--   - All URL patterns configured
