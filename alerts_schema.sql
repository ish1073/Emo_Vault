-- Alerts Module Database Schema
-- Creates tables for alerts and user preferences

-- Drop existing tables if they exist (optional)
-- DROP TABLE IF EXISTS alerts;
-- DROP TABLE IF EXISTS user_alert_preferences;

-- Main alerts table
CREATE TABLE IF NOT EXISTS alerts (
    alert_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    related_data_id VARCHAR(50),
    action_url VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dismissed_at TIMESTAMP NULL,
    is_dismissed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_user_alerts (user_id, is_dismissed),
    INDEX idx_created_at (created_at),
    INDEX idx_alert_type (alert_type)
);

-- User alert preferences table
CREATE TABLE IF NOT EXISTS user_alert_preferences (
    preference_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL UNIQUE,
    emotional_risk_enabled BOOLEAN DEFAULT TRUE,
    behavioral_pattern_enabled BOOLEAN DEFAULT TRUE,
    habit_disruption_enabled BOOLEAN DEFAULT TRUE,
    time_sensitive_enabled BOOLEAN DEFAULT TRUE,
    insight_enabled BOOLEAN DEFAULT FALSE,
    min_sensitivity INT DEFAULT 2,
    email_notifications_enabled BOOLEAN DEFAULT FALSE,
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert default preferences for existing users (if they don't have them)
-- This ensures all users have alert preferences
INSERT INTO user_alert_preferences (preference_id, user_id)
SELECT CONCAT('PREF_', user_id), user_id 
FROM users
WHERE user_id NOT IN (SELECT user_id FROM user_alert_preferences)
ON DUPLICATE KEY UPDATE user_id = user_id;

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_alerts_user_dismissed ON alerts(user_id, is_dismissed);
CREATE INDEX IF NOT EXISTS idx_alerts_user_type ON alerts(user_id, alert_type);
CREATE INDEX IF NOT EXISTS idx_alerts_priority ON alerts(priority);
CREATE INDEX IF NOT EXISTS idx_preferences_user ON user_alert_preferences(user_id);
