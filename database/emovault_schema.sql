-- EmoVault Database Schema
-- Creating database and tables for Emotional Intelligence System

DROP DATABASE IF EXISTS emovault;
CREATE DATABASE emovault;
USE emovault;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- Emotion Entries Table
CREATE TABLE emotion_entries (
    entry_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    trigger VARCHAR(500) NOT NULL,
    mood VARCHAR(50) NOT NULL,
    intensity INT CHECK (intensity >= 1 AND intensity <= 10),
    response TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
);

-- ============================================
-- DIARY TABLES
-- ============================================
Insert demo user (password: test123)
INSERT INTO users (name, email, password) VALUES 
('Demo User', 'demo@emovault.com', '202cb962ac59075b964b07152d234b70');