-- EmoVault Test Data Script
-- This creates a test user with sample emotions, time capsules, and other data

-- 1. Create or get test user
INSERT INTO users (name, email, password) VALUES ('Test User', 'testuser@example.com', 'test123')
ON DUPLICATE KEY UPDATE user_id=LAST_INSERT_ID(user_id);

-- Get the test user ID (assuming it's the most recently created)
SET @userId = LAST_INSERT_ID();

-- 2. Create test emotion entries (at least 3 required for analyzer)
INSERT INTO emotions (user_id, mood, intensity, trigger, response, created_at) VALUES
(@userId, 'Stressed', 7, 'Work deadline', 'Took a break', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(@userId, 'Happy', 8, 'Good news', 'Celebrated', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(@userId, 'Sad', 6, 'Sad news', 'Talked to friend', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(@userId, 'Excited', 9, 'Achievement', 'Shared joy', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(@userId, 'Calm', 4, 'Meditation', 'Relaxed', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(@userId, 'Anxious', 6, 'Work issue', 'Exercised', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(@userId, 'Peaceful', 5, 'Nature walk', 'Enjoyed moment', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(@userId, 'Frustrated', 8, 'Traffic', 'Took a walk', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- 3. Create test time capsules (for reflections feature)
INSERT INTO time_capsules (user_id, message, goal, mood, target_date, opened, opened_at) VALUES
(@userId, 'I want to achieve better work-life balance this quarter', 'Improve daily routine and stress management', 'Hopeful', DATE_SUB(NOW(), INTERVAL 30 DAY), 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(@userId, 'I hope to be more confident in presentations', 'Overcome presentation anxiety', 'Determined', DATE_ADD(NOW(), INTERVAL 60 DAY), 0, NULL),
(@userId, 'I want to build a meditation habit', 'Daily 10-minute meditation for mental peace', 'Peaceful', DATE_SUB(NOW(), INTERVAL 15 DAY), 1, DATE_SUB(NOW(), INTERVAL 10 DAY));

-- 4. Add reflections to first opened capsule
UPDATE time_capsules SET 
    reflection = 'I''ve made good progress! I''ve started implementing a better morning routine and have been more mindful of my work hours. While not perfect, I can see the difference in my stress levels. I''m committed to continuing this journey.',
    reflection_mood = 'Grateful',
    achievement_status = 'Partially'
WHERE user_id = @userId AND opened = 1 LIMIT 1;

-- 5. Create test diary entries
INSERT INTO diary_entries (user_id, title, content, mood, created_at) VALUES
(@userId, 'Monday Reflection', 'Started the week with renewed energy and focus. Managed to complete my meditation practice this morning.', 'Hopeful', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(@userId, 'Productive Day', 'Had an amazing day at work. Completed three important projects and received positive feedback from team.', 'Excited', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(@userId, 'Challenging Moments', 'Today was tough. Had conflicts with a coworker but we resolved it by evening. Feeling better now.', 'Calm', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(@userId, 'Weekend Peace', 'Spent the weekend with family. Very relaxing and rejuvenating. Feel recharged for the week ahead.', 'Peaceful', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(@userId, 'New Insights', 'Realized that my stress levels are directly connected to how much I exercise. Need to prioritize fitness.', 'Calm', NOW());

-- 6. Create test habits
INSERT INTO habits (user_id, title, streak, is_active, consistency_score, created_at) VALUES
(@userId, 'Morning Meditation', 7, 1, 85.0, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(@userId, 'Evening Exercise', 3, 1, 65.0, DATE_SUB(NOW(), INTERVAL 15 DAY)),
(@userId, 'Journaling', 5, 1, 75.0, DATE_SUB(NOW(), INTERVAL 20 DAY)),
(@userId, 'Reading', 0, 0, 45.0, DATE_SUB(NOW(), INTERVAL 30 DAY));

-- 7. Create test regrets
INSERT INTO regrets (user_id, description, lesson_learned, tag, created_date) VALUES
(@userId, 'Postponed important meeting by a week, causing miscommunication', 'Communication delays can create more problems. Better to address issues directly.', 'communication', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(@userId, 'Skipped exercise for 3 days due to stress', 'Exercise actually helps with stress management. Don''t skip when stressed.', 'health', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(@userId, 'Said something hurtful in anger', 'Take a break before responding in anger. Words matter.', 'relationships', DATE_SUB(NOW(), INTERVAL 3 DAY));

-- 8. Create test time capsules (additional)
INSERT INTO time_capsules (user_id, message, goal, mood, target_date, opened, reflection, reflection_mood, achievement_status, opened_at) VALUES
(@userId, 'Learn a new programming skill', 'Master TypeScript and React basics', 'Excited', DATE_SUB(NOW(), INTERVAL 20 DAY), 1, 'I''ve completed 5 online courses and started a project. Making steady progress!', 'Happy', 'Achieved', DATE_SUB(NOW(), INTERVAL 8 DAY));

SELECT 'Test data created successfully!' AS Status;
SELECT CONCAT('Test User ID: ', @userId) AS UserInfo;
SELECT 'Login with: testuser@example.com / test123' AS LoginInfo;
SELECT COUNT(*) as 'Total Emotions' FROM emotions WHERE user_id = @userId;
SELECT COUNT(*) as 'Total Diary Entries' FROM diary_entries WHERE user_id = @userId;
SELECT COUNT(*) as 'Total Time Capsules' FROM time_capsules WHERE user_id = @userId;
